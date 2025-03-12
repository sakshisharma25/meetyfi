from fastapi import HTTPException, status, Depends
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from datetime import datetime, timedelta, date, time
import jwt
import secrets
import string
import random
from typing import Dict, Any, Optional

from app.database import Manager, Employee, Admin, UserType
from app.schemas.auth import (
    ManagerSignupRequest, LoginRequest, VerifyOTPRequest, 
    EmployeeVerifyRequest, UserData
)
from app.config import settings
from app.utils.email import send_otp_email, send_employee_verification_email
from app.utils.password import hash_password, verify_password
from app.exceptions import (
    CredentialsException, UserNotFoundException, 
    OTPVerificationException, VerificationTokenException
)

def generate_random_id(length=8):
    """Generate a random alphanumeric ID"""
    characters = string.ascii_uppercase + string.digits
    return ''.join(random.choice(characters) for _ in range(length))

def generate_otp() -> str:
    """Generate a 6-digit OTP"""
    return ''.join(secrets.choice(string.digits) for _ in range(6))

def create_access_token(data: Dict[str, Any]) -> str:
    """
    Create a JWT access token
    
    Args:
        data: Data to encode in the token
        
    Returns:
        str: JWT token
    """
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt

def register_manager(db: Session, manager_data: ManagerSignupRequest):
    """
    Register a new manager

    Args:
        db: Database session
        manager_data: Manager signup data

    Returns:
        dict: Contains manager_id and message
    """
    # Check if email already exists
    existing_manager = db.query(Manager).filter(Manager.email == manager_data.email).first()
    if existing_manager:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )

    # Create new manager
    hashed_password = hash_password(manager_data.password)
    otp = generate_otp()

    # Generate a random manager_id
    random_manager_id = generate_random_id()

    # Ensure the random ID is unique
    while db.query(Manager).filter(Manager.manager_id == random_manager_id).first():
        random_manager_id = generate_random_id()

    new_manager = Manager(
        email=manager_data.email,
        password=hashed_password,
        name=manager_data.name,
        company_name=manager_data.company_name,
        company_size=manager_data.company_size,
        phone=manager_data.phone,
        profile_picture=manager_data.profile_picture,
        manager_id=random_manager_id,  # Add the random manager_id
        otp=otp,
        otp_created_at=datetime.utcnow(),
        is_verified=False,
        is_approved=False
    )

    try:
        db.add(new_manager)
        db.commit()
        db.refresh(new_manager)

        # Send OTP email
        send_otp_email(manager_data.email, otp, manager_data.name)

        return {
            "manager_id": new_manager.id,  # Database ID
            "custom_manager_id": random_manager_id,  # Random manager ID
            "message": "Manager registered successfully"
        }
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Error creating manager account"
        )

def verify_manager_otp(db: Session, request: VerifyOTPRequest):
    """
    Verify OTP for manager signup

    :param db: Database session
    :param request: VerifyOTPRequest containing email and OTP
    :return: VerifyOTPResponse with access token and user data
    :raises: HTTPException if OTP is invalid
    """
    # Find the manager by email
    manager = db.query(Manager).filter(Manager.email == request.email).first()
    if not manager:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Manager not found"
        )

    # Check if OTP matches
    if manager.otp != request.otp:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid OTP"
        )

    # Mark manager as verified
    manager.is_verified = True
    manager.otp = None  # Clear OTP after verification
    manager.otp_expiry = None  # Clear OTP expiry

    db.commit()

    # Generate JWT token
    access_token = create_access_token(
        data={"sub": manager.email, "user_type": "manager", "user_id": manager.id}
    )

    # Prepare user data
    user_data = {
        "id": manager.id,
        "email": manager.email,
        "name": manager.name,
        "user_type": "manager",
        "is_verified": manager.is_verified,
        "company_name": manager.company_name,
        "company_size": manager.company_size,
        "manager_id" : manager.manager_id,
    }

    return {
        "message": "OTP verified successfully",
        "access_token": access_token,
        "user_data": user_data
    }

def login_user(db: Session, login_data: LoginRequest) -> Dict[str, Any]:
    """
    Authenticate a user
    
    Args:
        db: Database session
        login_data: Login credentials
        
    Returns:
        Dict: Access token and user data
    """
    if login_data.user_type == UserType.MANAGER:
        user = db.query(Manager).filter(Manager.email == login_data.email).first()
    elif login_data.user_type == UserType.EMPLOYEE:
        user = db.query(Employee).filter(Employee.email == login_data.email).first()
    elif login_data.user_type == UserType.ADMIN:
        user = db.query(Admin).filter(Admin.email == login_data.email).first()
    else:
        raise CredentialsException("Invalid user type")
    
    if not user:
        raise CredentialsException("Invalid credentials")
    
    if not verify_password(login_data.password, user.password):
        raise CredentialsException("Invalid credentials")
    
    # For admins, they're always considered verified
    if login_data.user_type == UserType.ADMIN:
        user.is_verified = True
    
    # Ensure the user is verified (except for admins, as they are always verified)
    if login_data.user_type != UserType.ADMIN and not user.is_verified:
        raise CredentialsException("Account not verified")
    
    # For managers, check if approved
    if login_data.user_type == UserType.MANAGER and not user.is_approved:
        raise CredentialsException("Manager account not approved by admin")
    
    # Generate access token
    access_token = create_access_token({
        "sub": str(user.id),
        "type": login_data.user_type
    })
    
    # Prepare user data based on type
    user_data = UserData(
        id=user.id,
        email=user.email,
        name=user.name,
        user_type=login_data.user_type,
        is_verified=user.is_verified
    )
    
    if login_data.user_type == UserType.MANAGER:
        user_data.company_name = user.company_name
        user_data.company_size = user.company_size
    elif login_data.user_type == UserType.EMPLOYEE:
        user_data.role = user.role
        user_data.department = user.department
        user_data.manager_id = user.manager_id
    
    return {
        "access_token": access_token,
        "user_data": user_data
    }

def create_employee(db: Session, manager_id: str, name: str, email: str, role: Optional[str] = None, department: Optional[str] = None) -> int:
    """
    Create a new employee
    
    Args:
        db: Database session
        manager_id: ID of the manager creating the employee
        name: Employee name
        email: Employee email
        role: Employee role
        department: Employee department
        
    Returns:
        int: ID of the created employee
    """
    # Check if email already exists
    existing_employee = db.query(Employee).filter(Employee.email == email).first()
    if existing_employee:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    # Generate verification token
    verification_token = secrets.token_urlsafe(32)
    
    # Create new employee
    new_employee = Employee(
        email=email,
        name=name,
        role=role,
        department=department,
        manager_id=manager_id,
        verification_token=verification_token,
        verification_token_created_at=datetime.utcnow(),
        is_verified=False
    )
    
    try:
        db.add(new_employee)
        db.commit()
        db.refresh(new_employee)
        
        # Get manager details
        manager = db.query(Manager).filter(Manager.id == manager_id).first()
        
        # Send verification email
        send_employee_verification_email(
            email, 
            name, 
            verification_token, 
            manager.name, 
            manager.company_name
        )
        
        return new_employee.id
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Error creating employee account"
        )

def verify_employee(db: Session, verify_data: EmployeeVerifyRequest) -> Dict[str, Any]:
    """
    Verify employee account with verification token and set password

    Args:
        db: Database session
        verify_data: Employee verification data

    Returns:
        Dict: Contains access token and user data
    """
    try:
        # Find employee by verification token
        employee = db.query(Employee).filter(Employee.verification_token == verify_data.verification_token).first()

        if not employee:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Invalid verification token"
            )

        # Check if token is expired
        if employee.token_expiry and employee.token_expiry < datetime.utcnow():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Verification token expired"
            )

        # Set password and mark as verified
        hashed_password = hash_password(verify_data.password)
        employee.password = hashed_password
        employee.is_verified = True
        employee.verification_token = None
        employee.token_expiry = None

        db.commit()

        # Generate access token
        access_token = create_access_token({
            "sub": str(employee.id),
            "type": UserType.EMPLOYEE.value
        })

        # Prepare user data
        user_data = {
            "id": employee.id,
            "email": employee.email,
            "name": employee.name,
            "user_type": UserType.EMPLOYEE.value,
            "is_verified": True,
            "role": employee.role,
            "department": employee.department,
            "manager_id": employee.manager_id
        }

        return {
            "access_token": access_token,
            "user_data": user_data,
            "message": "Account verified successfully"
        }

    except Exception as e:
        db.rollback()
        # Log the specific error for debugging
        print(f"Error in verify_employee: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error verifying employee: {str(e)}"
        )