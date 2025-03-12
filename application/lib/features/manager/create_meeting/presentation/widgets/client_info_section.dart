import 'package:flutter/material.dart';
import 'package:Meetyfi/features/manager/create_meeting/presentation/widgets/meeting_text_field.dart';

class ClientInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? Function(String?)? validateName;
  final String? Function(String?)? validateEmail;
  final String? Function(String?)? validatePhone;

  const ClientInfoSection({
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
    return Column(
      children: [
        MeetingTextField(
          controller: nameController,
          label: 'Client Name',
          hint: 'Enter client name',
          validator: validateName,
        ),
        const SizedBox(height: 16),
        MeetingTextField(
          controller: emailController,
          label: 'Client Email',
          hint: 'Enter client email',
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
        ),
        const SizedBox(height: 16),
        MeetingTextField(
          controller: phoneController,
          label: 'Client Phone',
          hint: 'Enter client phone number',
          keyboardType: TextInputType.phone,
          validator: validatePhone,
        ),
      ],
    );
  }
}