class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "ສະມາຄົມສະຖານີຄິວລົດ",
    image: "assets/images/1.png",
    desc: "ຢ່າລືມຕິດຕາມຄວາມສໍາເລັດອາຊີບຂອງເຈົ້າ.",
  ),
  OnboardingContents(
    title: "ເດີນທາງດ້ວຍຄວາມປອດໄພ",
    image: "assets/images/6.png",
    desc:
        "ແຕ່ການທໍາຄວາມເຂົ້າໃຈການມີສ່ວນຮ່ວມທີເພື່ອນຮ່ວມງານຂອງເຮົາມີຕໍ່ທີມ ແລະ ບໍລິສັດຂອງເຮົາ.",
  ),
  OnboardingContents(
    title: "ສະຖານີຄິວລົດແຂວງ ຫຼວງພະບາງ",
    image: "assets/images/5.png",
    desc: "ຄວບຄຸມການແຈ້ງເຕື່ອນ ທໍາງານຮ່ວມກັນຕາມເວລາຂອງເຈົ້າເອງ.",
  ),
];
