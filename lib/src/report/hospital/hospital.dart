import 'package:flutter/material.dart';
import 'hospital_tab.dart';
import 'hospital_info.dart';

class HospitalInfoDisplay extends StatefulWidget {
  const HospitalInfoDisplay({super.key});

  @override
  State<HospitalInfoDisplay> createState() => _HospitalInfoDisplayState();
}

class _HospitalInfoDisplayState extends State<HospitalInfoDisplay> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<HospitalInfo> filteredHospitals = HospitalInfoProvider.hospitalList.where(
      (hospital) {
        return hospital.name.contains(searchQuery);
      },
    ).toList();

    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "แนะนำโรงพยาบาล",
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
              image: AssetImage("assets/images/light_green_background.avif"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                    bottom: 30.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  searchQuery = "";
                                });
                              },
                            )
                          : null,
                      hintText: "ค้นหา",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredHospitals.length,
                    itemBuilder: (BuildContext context, int index) {
                      return HospitalTabView(hospital: filteredHospitals[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HospitalTabView extends StatelessWidget {
  const HospitalTabView({super.key, required this.hospital});
  final HospitalInfo hospital;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HospitalInfoView(hospital: hospital),
          ),
        );
      },
      leading: Icon(
        Icons.local_hospital,
        size: 30,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        hospital.name,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
