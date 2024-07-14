class HospitalInfoProvider {
  static const List<HospitalInfo> hospitalList = [
    HospitalInfo(
      "โรงพยาบาลศิริราช",
      "2 ถ. วังหลัง แขวงศิริราช เขตบางกอกน้อย กรุงเทพฯ 10700 ",
      "เปิดตลอด 24 ชม.",
      "02-206-2900",
      "crm@rajavithi.go.th",
      "assets/hospital_images/siriraj.jpg",
    ),
    HospitalInfo(
      "โรงพยาบาลราชวิถี",
      "2 ถ. พญาไท แขวงทุ่งพญาไท เขตราชเทวี กรุงเทพมหานคร 10400",
      "เปิดตลอด 24 ชม.",
      "02-206-2900",
      "crm@rajavithi.go.th",
      "assets/hospital_images/rajavithi.jpg",
    ),
    HospitalInfo(
      "โรงพยาบาลนพรัตนราชธานี",
      "679 ถ.รามอินทรา กม.13 แขวงคันนายาว เขตคันนายาว กรุงเทพมหานคร 10230",
      "เปิดตลอด 24 ชม.",
      "02-548-1000",
      "info@nopparat.go.th",
      "assets/hospital_images/nopparut.jpg",
    ),
    HospitalInfo(
      "โรงพยาบาลสินแพทย์ เสรีรักษ์",
      "44 ถ.เสรีไทย แขวงมีนบุรี เขตมีนบุรี กรุงเทพมหานคร 10510",
      "เปิดตลอด 24 ชม.",
      "02-761-9888",
      "seriruk@synphaet.co.th",
      "assets/hospital_images/seriruk.jpg",
    ),
    HospitalInfo(
      "โรงพยาบาลศิริราช ปิยมหาราชการุณย์",
      "2 ถ. วังหลัง แขวงศิริราช เขตบางกอกน้อย กรุงเทพมหานคร 10700",
      "แผนกผู้ป่วยนอก 07:00 - 21:00 น., แผนกฉุกเฉินเปิดตลอด 24 ชม.",
      "02-419-1000",
      "info@siphhospital.com",
      "assets/hospital_images/siriraj_piyamahakarun.jpg",
    ),
    HospitalInfo(
      "โรงพยาบาลจุฬาภรณ์",
      "54 หมู่ 4 ถ.กำแพงเพชร 6 แขวงตลาดบางเขน เขตหลักสี่ กรุงเทพมหานคร 10210",
      "เปิดตลอด 24 ชม.",
      "02-576-6000",
      "info@cccthai.org",
      "assets/hospital_images/chulabhorn.jpg",
    ),
    HospitalInfo(
      "โรงพยาบาลรามาธิบดี",
      "270 ถ.พระรามที่ 6 แขวงทุ่งพญาไท เขตราชเทวี กรุงเทพมหานคร 10400",
      "เปิดตลอด 24 ชม.",
      "02-201-1000",
      "webmaster@mahidol.ac.th",
      "assets/hospital_images/ramathibodhi.webp",
    ),
  ];
}

class HospitalInfo {
  final String name;
  final String location;
  final String openHours;
  final String phone;
  final String gmail;
  final String imagePath;

  const HospitalInfo(
    this.name,
    this.location,
    this.openHours,
    this.phone,
    this.gmail,
    this.imagePath,
  );
}
