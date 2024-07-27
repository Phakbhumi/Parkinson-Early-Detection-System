import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'hospital_info.dart';

class HospitalInfoView extends StatelessWidget {
  const HospitalInfoView({super.key, required this.hospital});
  final HospitalInfo hospital;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            hospital.name,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/light_green_background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50.0,
                bottom: 50.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                children: [
                  Image.asset(
                    hospital.imagePath,
                    fit: BoxFit.cover,
                  ),
                  const Gap(20),
                  Text(
                    hospital.name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Gap(10),
                  ExplainText(
                    "สถานที่ตั้ง:  ",
                    hospital.location,
                  ),
                  const Gap(10),
                  ExplainText(
                    "เวลาเปิด-ปิด:  ",
                    hospital.openHours,
                  ),
                  const Gap(10),
                  Contacts(phone: hospital.phone, gmail: hospital.gmail),
                  const Gap(10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Contacts extends StatelessWidget {
  const Contacts({
    super.key,
    required this.phone,
    required this.gmail,
  });
  final String phone;
  final String gmail;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "ช่องทางการติดต่อ",
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Gap(12),
        MatchText(Icons.phone, phone),
        const Gap(8),
        MatchText(Icons.mail, gmail),
      ],
    );
  }
}

class ExplainText extends StatelessWidget {
  const ExplainText(this.header, this.content, {super.key});
  final String header;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MatchText extends StatelessWidget {
  const MatchText(this.icon, this.content, {super.key});
  final IconData icon;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(20),
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const Gap(20),
      ],
    );
  }
}
