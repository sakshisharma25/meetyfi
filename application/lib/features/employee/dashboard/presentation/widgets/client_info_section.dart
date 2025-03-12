import 'package:flutter/material.dart';
import 'package:Meetyfi/features/employee/dashboard/presentation/widgets/meeting_text_field.dart';

class ClientInfoSectionE extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? Function(String?)? validateName;
  final String? Function(String?)? validateEmail;
  final String? Function(String?)? validatePhone;

  const ClientInfoSectionE({
    Key? key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    this.validateName,
    this.validateEmail,
    this.validatePhone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          MeetingTextFieldE(
            controller: nameController,
            label: 'Client Name',
            hint: 'Enter client name',
            validator: validateName,
          ),
          const SizedBox(height: 16),
          MeetingTextFieldE(
            controller: emailController,
            label: 'Client Email',
            hint: 'Enter client email',
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
          ),
          const SizedBox(height: 16),
          MeetingTextFieldE(
            controller: phoneController,
            label: 'Client Phone',
            hint: 'Enter client phone number',
            keyboardType: TextInputType.phone,
            validator: validatePhone,
          ),
        ],
      ),
    );
  }
}