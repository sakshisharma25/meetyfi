from fastapi import Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from jose import JWTError
from app.database import Manager, Employee, Admin, UserType
from app.config import settings
from app.utils.security import verify_token
from app.data import get_db_session

def get_db():
    db = get_db_session()  # Ensure this function returns a Session object, not a generator
    try:
        return db
    finally:
        db.close()

async def get_current_user(authorization: str = Header(...), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    # Extracting the token from the Authorization header (Bearer <token>)
    try:
        token = authorization.split(" ")[1]  # assuming format is "Bearer <token>"
    except IndexError:
        raise credentials_exception

    try:
        payload = verify_token(token)
        user_id: int = payload.get("sub")
        user_type: str = payload.get("type")

        if user_id is None or user_type is None:
            raise credentials_exception

        if user_type == UserType.MANAGER:
            user = db.query(Manager).filter(Manager.id == user_id).first()
        elif user_type == UserType.EMPLOYEE:
            user = db.query(Employee).filter(Employee.id == user_id).first()
        elif user_type == UserType.ADMIN:
            user = db.query(Admin).filter(Admin.id == user_id).first()
        else:
            raise credentials_exception

        if user is None:
            raise credentials_exception

        return user
    except JWTError:
        raise credentials_exception

async def get_current_manager(current_user = Depends(get_current_user)):
    if not isinstance(current_user, Manager):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to access this resource"
        )
    return current_user

async def get_current_employee(current_user = Depends(get_current_user)):
    if not isinstance(current_user, Employee):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to access this resource"
        )
    return current_user

async def get_current_admin(current_user = Depends(get_current_user)):
    if not isinstance(current_user, Admin):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to access this resource"
        )
    return current_user
