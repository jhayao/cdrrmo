class BookModel {
  String image;
  String secondImage;
  String title;
  String subtitle;
  bool favorite;
  String description;

  BookModel(
      {required this.image,
      required this.secondImage,
      required this.title,
      required this.subtitle,
      required this.favorite,
        required this.description});

  //Yeni Kitaplar
  static BookModel newBook = BookModel(
    image: "lib/assets/images/new_book_1.jpeg",
    secondImage: "lib/assets/images/new_book_2.jpeg",
    title: "Raft Of Stars",
    subtitle: "Andrew J. Graff",
    favorite: true,
      description: "null"
  );


  static List<BookModel> book = [
    BookModel(
        image: "lib/assets/images/book_1_1.jpeg",
        secondImage: "lib/assets/images/book_1_1.jpeg",
        title: "İnsan Ne İle Yaşar?",
        subtitle: "Tolstoy",
        favorite: false,
        description: "Lev Nikolayeviç Tolstoy (1828-1910): Anna Karenina, Savaş ve Barış, Kreutzer Sonat ve Diriliş'in büyük yazarı, yaşamının son otuz yılında kendini insan, aile, din, devlet, toplum, özgürlük, boyun eğme, başkaldırma, sanat ve estetik konularında kuramsal çalışmalara verdi. Bu dönemde yazdığı öykülerde yıllarca üzerinde düşündüğü insanlık sorunlarını edebi bir kurgu içinde ele aldı. Tolstoy, insan sevgisi ve inanç konularını ustalığının bütün inceliğiyle işlerken, İnsan Neyle Yaşar? ile gerçek hayatı yansıtan tabloların içinde yeni bir ahlak anlayışını ortaya koydu."),
    BookModel(
        image: "lib/assets/images/book_2_2.jpeg",
        secondImage: "lib/assets/images/book_2_2.jpeg",
        title: "Yeraltından Notlar",
        subtitle: "Fyodor Dostoyevski",
        favorite: false,
        description: "İnsan psikolojisi, sevgi ve nefret üzerine ateşli tartışmalar yaratan bir başyapıt…Dostoyevski bu romanda, içe dönük, ezik ama saygınlık arayışında olan ‘kentli ve yalnız’ insanın dramını gözler önüne seriyor.İnsanoğlu kendi yararının tersine davranabilir mi? Aşk kurtuluş mu, yoksa tuzak mıdır? Yazar bu ve benzeri evrensel sorunlara çarpıcı ve irkiltici yanıtlar veriyor."),
    BookModel(
        image: "lib/assets/images/book_3_3.jpeg",
        secondImage: "lib/assets/images/book_3_3.jpeg",
        title: "Yabancı",
        subtitle: "Albert Camus",
        favorite: false,
        description: "Albert Camus’nün nobel edebiyat ödüllü bu eseri ile sizi de hayata karşı derin düşüncelere dalacağınız bir yolculuk bekliyor. Önce “İnsan bu kadar vurdumduymaz olur mu?” diye düşünecek, ardından insanı buna iten nedenler hakkında bir iç sorgulamaya varacaksınız. Kütüphanenizden eksik etmemeniz gereken bir roman daha Albert Camus’nün güçlü kalemiyle karşınızda…"),
    BookModel(
        image: "lib/assets/images/book_4_4.jpeg",
        secondImage: "lib/assets/images/book_4_4.jpeg",
        title: "Gün Olur Asra Bedel",
        subtitle: "Cengiz Aytmatov",
        favorite: false,
        description: "Bir güne kaç hatıra, kaç yaşanmışlık, kaç hikâye sığdırılabilir? Söz konusu olan uzun bir yolculuksa, sayısız... Yeri doldurulamaz bir geçmişi paylaştığı dostunun cenazesini taşıyan Yedigey’in yolculuğu, bütünüyle yaşamı soruşturan bir yolculuk olacaktır elbette; uzak hatıralardan söylencelere, sade mutluluklardan acılı ölümlere, maddi yoksulluklardan manevi zenginliklere, geçmişin özünde ve kıyılarında dolaştıran bir yolculuk…"),
    BookModel(
        image: "lib/assets/images/book_5_5.jpeg",
        secondImage: "lib/assets/images/book_5_5.jpeg",
        title: "Tutunamayanlar",
        subtitle: "Oğuz Atay",
        favorite: false,
        description: "Tutunamayanlar Oğuz Atay ismiyle özdeşleşmiş bir roman olarak, büyük yazarımızın hayatından izler taşımasıyla da kısmen otobiyografik bir eser olarak da değerlendirilebilir. Roman, son derece üst düzey diliyle çevirisi en zor romanlar arasında yer alır. Tutunamayanlar, sadece birkaç dile çevrilebilmiştir. “Het leven in stukken” adı altında Flemenkçeye (Hollanda Dili) çevrilen eser, eserin Hollandalı çevirmenine ödül kazandırmıştır."),
    BookModel(
        image: "lib/assets/images/book_1.jpeg",
        secondImage: "lib/assets/images/book_1.jpeg",
        title: "The Martian",
        subtitle: "Andy Weir",
        favorite: false,
        description: "Andy Weir'in yazdığı Marslı şimdiye kadar okuduğum en iyi bilimsel bilimkurgu romanı. Bu romanı -başka bir kitap hakkında hiç böyle bir şey söylemedim- edebi anlamda da elden bırakmak mümkün değil.-Dan Simmons, Hugo ödüllü Hyperion serisinin yazarı-"),
    BookModel(
        image: "lib/assets/images/book_2.jpeg",
        secondImage: "lib/assets/images/book_2.jpeg",
        title: "Midnight War",
        subtitle: "Mateo Martinez",
        favorite: false,
        description: "null"),
    BookModel(
        image: "lib/assets/images/book_3.jpeg",
        secondImage: "lib/assets/images/book_3.jpeg",
        title: "The Hypocrite World",
        subtitle: "Sophia Hill",
        favorite: false,
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
    BookModel(
        image: "lib/assets/images/book_4.jpeg",
        secondImage: "lib/assets/images/book_4.jpeg",
        title: "Amara The Brave",
        subtitle: "Matt Zhang",
        favorite: true,
        description: "null"),
    BookModel(
        image: "lib/assets/images/book_5.jpeg",
        secondImage: "lib/assets/images/book_5.jpeg",
        title: "Harry Potter",
        subtitle: "A History Of Magic",
        favorite: true,
        description: "*Kanıtlar, bazen, zihninin en rahat ve etkiye en açık olduğu durumlarında –örneğin uyurken– Karanlık Lord’un düşüncelerini ve duygularını paylaştığına işaret ediyor. Müdür bunun devam etmesini uygun bulmuyor. Benim sana, zihnini Karanlık Lord’a karşı nasıl kapatacağını öğretmemi istiyor.*"),
  ];
}
