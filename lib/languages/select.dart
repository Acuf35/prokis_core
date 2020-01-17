

class SelectLanguage{

  selectStrings(String language, String kod){

    String metin="";
    language == 'TR' ? metin = languageTR(kod) : metin = languageEN(kod) ;

    return metin;

  }

  languageTR(String kod){

    String metin="0kod";

    kod=='slogan' ? metin='Programlanabilir Kümes İklimlendirme Sistemi' : null;

    kod=='pdiag1' ? metin='Kontrol ediliyor…' : null;
    kod=='cbox2' ? metin='Kurulum ayarlarını sistemden çek' : null;

    //#region TEXTVIEW

    kod=="tv1" ? metin='Dil Seçimi' : null;
    kod=="tv2" ? metin='Temel Ayarlar' : null;
    kod=="tv3" ? metin='Kafes Türü' : null;
    kod=="tv4" ? metin='Kümes No' : null;
    kod=="tv5" ? metin='Kümes İsmi' : null;
    kod=="tv6" ? metin='Kümes ismi için tıklayınız…' : null;
    kod=="tv7" ? metin='Admin şifresi tanımlayınız…' : null;
    kod=="tv8" ? metin='Admin Şifresi' : null;
    kod=="tv9" ? metin='Şifreyi doğrulayın…' : null;
    kod=="tv10" ? metin='Admin Şifresi Tekrar' : null;
    kod=="tv11" ? metin='Kontrol Eleman Adetleri' : null;
    kod=="tv12" ? metin='Fan Sayısı' : null;
    kod=="tv13" ? metin='Klepe Sayısı' : null;
    kod=="tv14" ? metin='Ped Pompa Sayısı' : null;
    kod=="tv15" ? metin='Isı Sens. Sayısı' : null;
    kod=="tv16" ? metin='Bacafan Grup Sayısı' : null;
    kod=="tv17" ? metin='A.Inlet M.Sayısı' : null;
    kod=="tv18" ? metin='Isıtıcı Sayısı' : null;
    kod=="tv19" ? metin='Silo Sayısı' : null;
    kod=="tv20" ? metin='Fan Kontrol Yontemi' : null;
    kod=="tv21" ? metin='Klasik Kontrol' : null;
    kod=="tv22" ? metin='Lineer Kontrol' : null;
    kod=="tv23" ? metin='PID Kontrol' : null;
    kod=="tv24" ? metin='Min. Hav. Kontrol Yöntemi' : null;
    kod=="tv25" ? metin='Ağırlık Kontrol' : null;
    kod=="tv26" ? metin='Hacim Kontrol' : null;
    kod=="tv27" ? metin='Klepe Kontrol Yöntemi' : null;
    kod=="tv28" ? metin='Tünel Kontrol' : null;
    kod=="tv29" ? metin='Uzunluklar, Dış Nem ve Debi' : null;
    kod=="tv30" ? metin='Dış Nem' : null;
    kod=="tv31" ? metin='Fan Haritası' : null;
    kod=="tv32" ? metin='Fan:' : null;
    kod=="tv33" ? metin='Çkş:' : null;
    kod=="tv34" ? metin='FAN NO' : null;
    kod=="tv35" ? metin='ÇIKIŞ NO' : null;
    kod=="tv36" ? metin='Şifre uyuşması :' : null;
    kod=="tv37" ? metin='Harita sıfırlanacak! Emin misiniz?' : null;
    kod=="tv38" ? metin='Klepe Haritası' : null;
    kod=="tv39" ? metin='Klp:' : null;
    kod=="tv40" ? metin='KLEPE NO' : null;
    kod=="tv41" ? metin='AÇ ÇKŞ NO' : null;
    kod=="tv42" ? metin='KP ÇKŞ NO' : null;
    kod=="tv43" ? metin='ÇkşAç:' : null;
    kod=="tv44" ? metin='ÇkşKp:' : null;
    kod=="tv45" ? metin='Ped:' : null;
    kod=="tv46" ? metin='PED NO' : null;
    kod=="tv47" ? metin='Ped Pompa Haritası' : null;
    kod=="tv48" ? metin='Isı Sensör Haritası' : null;
    kod=="tv49" ? metin='ISISen NO' : null;
    kod=="tv50" ? metin='Sens:' : null;
    kod=="tv51" ? metin='Kayıtlı Sensörler' : null;
    kod=="tv52" ? metin='Sens. No:' : null;
    kod=="tv53" ? metin='Ön Duvar' : null;
    kod=="tv54" ? metin='Sağ Duvar' : null;
    kod=="tv55" ? metin='Arka Duvar' : null;
    kod=="tv56" ? metin='Sol Duvar' : null;
    kod=="tv57" ? metin='Bina Üst Görünüş' : null;
    kod=="tv58" ? metin='Ön' : null;
    kod=="tv59" ? metin='Arka' : null;
    kod=="tv60" ? metin='Sisteme bağlı aktif sensör yok...' : null;
    kod=="tv61" ? metin='ISISen NO Atama' : null;
    kod=="tv62" ? metin='ÇIKIŞLAR' : null;
    kod=="tv63" ? metin='Grup:' : null;
    kod=="tv64" ? metin='Bfan Grup No' : null;
    kod=="tv65" ? metin='B.Fan Gr-1 Çkş No' : null;
    kod=="tv66" ? metin='B.Fan Gr-2 Çkş No' : null;
    kod=="tv67" ? metin='B.Fan Gr-3 Çkş No' : null;
    kod=="tv68" ? metin='Baca Fan Haritası' : null;
    kod=="tv69" ? metin='Bfan Grup Çıkış No' : null;
    kod=="tv70" ? metin='Dış Sıc. Sen.' : null;
    kod=="tv71" ? metin='Air Inlet Haritası' : null;
    kod=="tv72" ? metin='No:' : null;
    kod=="tv73" ? metin='Çkş:' : null;
    kod=="tv74" ? metin='A.INLET NO' : null;
    kod=="tv75" ? metin='Air:' : null;
    kod=="tv76" ? metin='Isıtıcı Haritası' : null;
    kod=="tv77" ? metin='Isıtıcı Gr-1 Çkş No' : null;
    kod=="tv78" ? metin='Isıtıcı Gr-2 Çkş No' : null;
    kod=="tv79" ? metin='Isıtıcı Gr-3 Çkş No' : null;
    kod=="tv80" ? metin='Isıtıcı Grup No' : null;
    kod=="tv81" ? metin='Boşta' : null;
    kod=="tv82" ? metin='Silo:' : null;
    kod=="tv83" ? metin='SİLO NO' : null;
    kod=="tv84" ? metin='Silo Haritası' : null;
    kod=="tv85" ? metin='Diğer Çıkışlar' : null;
    kod=="tv86" ? metin='ALARM' : null;
    kod=="tv87" ? metin='UYARI' : null;
    kod=="tv88" ? metin='AYDINLATMA' : null;
    kod=="tv89" ? metin='YEM 1 İleri' : null;
    kod=="tv90" ? metin='YEM 2 İleri' : null;
    kod=="tv91" ? metin='YEM 3 İleri' : null;
    kod=="tv92" ? metin='YEM 1 Geri' : null;
    kod=="tv93" ? metin='YEM 2 Geri' : null;
    kod=="tv94" ? metin='YEM 3 Geri' : null;
    kod=="tv95" ? metin='Yem 1 Aktif' : null;
    kod=="tv96" ? metin='Yem 2 Aktif' : null;
    kod=="tv97" ? metin='Yem 3 Aktif' : null;
    kod=="tv98" ? metin='Kurulumu Tamamla' : null;
    kod=="tv99" ? metin='GENEL AYARLAR' : null;
    kod=="tv100" ? metin='İZLEME' : null;
    kod=="tv101" ? metin='OTO-MAN' : null;
    kod=="tv102" ? metin='KONTROL' : null;
    kod=="tv103" ? metin='DATA LOG' : null;
    kod=="tv104" ? metin='ALARM AYAR.' : null;
    kod=="tv105" ? metin='KURULUM' : null;
    kod=="tv106" ? metin='KONTROL AYARLARI' : null;
    kod=="tv107" ? metin='SIC. ve FAN' : null;
    kod=="tv108" ? metin='KLEPE' : null;
    kod=="tv109" ? metin='SOĞUTMA' : null;
    kod=="tv110" ? metin='MİN. HAV.' : null;
    kod=="tv111" ? metin='ISITMA' : null;
    kod=="tv112" ? metin='AYDINLATMA' : null;
    kod=="tv113" ? metin='SİLO ve YEM' : null;
    kod=="tv114" ? metin='P. SİHİRBAZI' : null;
    kod=="tv115" ? metin='Set Sıcaklığı' : null;
    kod=="tv116" ? metin='Tünel hav. başl. sıcaklığı' : null;
    kod=="tv117" ? metin='Çapraz hav. bitiş sıcaklığı' : null;
    kod=="tv118" ? metin='Tünel hav. aktif alan' : null;
    kod=="tv119" ? metin='Çapraz hav. aktif alan' : null;
    kod=="tv120" ? metin='Min hav. aktif alan(sürekli)' : null;
    kod=="tv121" ? metin='Min hav. aktif alan(fasılalı)' : null;
    kod=="tv122" ? metin='Maks. fan sıcaklığı' : null;
    kod=="tv123" ? metin='Sıcaklık Diyagramı' : null;
    kod=="tv124" ? metin='Navigatör Menü' : null;

   
    

    //#endregion

    //region BUTTON

    kod=="btn1" ? metin='ONAYLA' : null;
    kod=="btn2" ? metin='ONAY' : null;
    kod=="btn3" ? metin='ÇIKIŞ' : null;
    kod=="btn4" ? metin='Harita Onay' : null;
    kod=="btn5" ? metin='Harita Sıfırla ' : null;
    kod=="btn6" ? metin='Verileri Gönder' : null;
    kod=="btn7" ? metin='EVET' : null;
    kod=="btn8" ? metin='HAYIR' : null;
    
    //endregion

    //region TEXTFIELD

    kod=="tflb1" ? metin='Tun. Fan Debi' : null;
    kod=="tflb2" ? metin='Bac. Fan Debi' : null;
    kod=="tflb3" ? metin='Hacim Oranı(%)' : null;


    kod=="tfhp1" ? metin='(m3/h)' : null;
    
    
    //endregion

    //region DROPDOWN LIST

    kod=="dd1" ? metin='TAVUK' : null;
    kod=="dd2" ? metin='CİVCİV' : null;
    kod=="dd3" ? metin='BROYLER' : null;
    

    //endregion

    //region HINT

    kod=="hint1" ? metin='Kümes İsmi' : null;

    //endregion

    //region TOAST

    kod=="toast1" ? metin='Lütfen en az 4 karakterlik bir kümes ismi belirleyiniz!' : null;
    kod=="toast2" ? metin='Lütfen 4 basamaklı bir sifre belirleyiniz!' : null;
    kod=="toast3" ? metin='Şifreler uyuşmuyor!' : null;
    kod=="toast4" ? metin='Fan kontrol yöntemlerinden en az biri seçilmiş olmalıdır!' : null;
    kod=="toast5" ? metin='Tanımlanan klepe sayısından büyük sayı girdiniz. Lütfen kontrol ediniz!' : null;
    kod=="toast6" ? metin='Klepe no , X(m) veya Y(m) değerinden biri veya birkaçı boş' : null;
    kod=="toast7" ? metin='X(m) veya Y(m) değerlerinden birine geçersiz bir girişi yapıldı' : null;
    kod=="toast8" ? metin='Başarılı' : null;
    kod=="toast9" ? metin='Bir veya daha fazla Klepe uzunluk değerleri girilmemiş' : null;
    kod=="toast10" ? metin='A(m), B(m), C(m) değerlerinden biri veya birkaçı boş!' : null;
    kod=="toast11" ? metin='Tünel Fan Debi veya Baca Fan Debi değerlerinden biri veya ikisi boş!' : null;
    kod=="toast12" ? metin='Hacim Oranı değeri boş!' : null;
    kod=="toast13" ? metin='A(m), B(m), C(m) değerlerinden biri veya birkaçına geçersiz değer girilmiş!' : null;
    kod=="toast14" ? metin='Tünel Fan Debi veya Baca Fan Debi değerlerinden biri veya ikisine geçersiz değer girilmiş!' : null;
    kod=="toast15" ? metin='Hacim Oranı değerine geçersiz değer girilmiş' : null;
    kod=="toast16" ? metin='Haritada seçilen fan sayısı, tanımlanandan eksik!' : null;
    kod=="toast17" ? metin='Haritada seçilen fan sayısı, tanımlanandan fazla!' : null;
    kod=="toast18" ? metin='Seçilen fan ve duvarlar dikdörtgen şekil oluşturmalıdır!' : null;
    kod=="toast19" ? metin='Tanımladığınız şifreyi onaylamanız gerekli!' : null;
    kod=="toast20" ? metin='Bağlantı Hatası!' : null;
    kod=="toast21" ? metin='Yeni şifre onaylandı' : null;
    kod=="toast22" ? metin='Min. Hav. kontrol yöntemlerinden en az biri seçilmiş olmalıdır!' : null;
    kod=="toast23" ? metin='Klepe kontrol yöntemlerinden en az biri seçilmiş olmalıdır!' : null;
    kod=="toast24" ? metin='Lütfen seçili tüm fanlar için sıfırdan farklı Fan No ve Çıkış No tanımlayınız!' : null;
    kod=="toast25" ? metin='Aynı Fan No iki farklı fan için tanımlanmış! Lütfen kontrol ediniz' : null;
    kod=="toast26" ? metin='Aynı Çıkış No iki farklı çıkış için tanımlanmış! Lütfen kontrol ediniz' : null;
    kod=="toast27" ? metin='Lütfen önce tanımladığınız verileri gönderiniz!' : null;
    kod=="toast28" ? metin='Aynı Klepe No iki farklı klepe için tanımlanmış! Lütfen kontrol ediniz' : null;
    kod=="toast29" ? metin='Haritada seçilen klepe sayısı, tanımlanandan eksik!' : null;
    kod=="toast30" ? metin='Haritada seçilen klepe sayısı, tanımlanandan fazla!' : null;
    kod=="toast31" ? metin='Aynı Isı Sensör No iki farklı Isı Sensör için tanımlanmış! Lütfen kontrol ediniz' : null;
    kod=="toast32" ? metin='Aynı Ped No iki farklı ped için tanımlanmış! Lütfen kontrol ediniz' : null;
    kod=="toast33" ? metin='Aktif sensörlerden ikisine aynı numara atanmış! Lütfen kontrol ediniz' : null;
    kod=="toast34" ? metin='En az bir tane aktif sensor atanmış olmalıdır' : null;
    kod=="toast35" ? metin='Lütfen seçili tüm ısı sensörler için sıfırdan farklı sensör no tanımlayınız!' : null;
    kod=="toast36" ? metin='Lütfen seçili tüm pedler için sıfırdan farklı Ped No ve Çıkış No tanımlayınız!' : null;
    kod=="toast37" ? metin='Lütfen seçili tüm klepeler için sıfırdan farklı Klepe No ve Çıkış No tanımlayınız!' : null;
    kod=="toast38" ? metin='Atanacak çıkışlardan biri şu anda kullanımda! Lütfen önce ilgili çıkışı boşa çıkarın' : null;
    kod=="toast39" ? metin='Lütfen harita üzerinde seçili tüm bacafanları için sıfırdan farklı grup no tanımlayınız!' : null;
    kod=="toast40" ? metin='Lütfen toplam sensör sayısına eşit veya daha küçük bir sayı tanımlayınız!' : null;
    kod=="toast41" ? metin='Seçilen sensör numarası harita üzerinde tanımlı değil!' : null;
    kod=="toast42" ? metin='Aynı Air Inlet No iki farklı air inlet için tanımlanmış! Lütfen kontrol ediniz!' : null;
    kod=="toast43" ? metin='Lütfen toplam bacafan grup sayısına eşit veya daha küçük bir no tanımlayınız! ' : null;
    kod=="toast44" ? metin='Lütfen toplam air inlet motor sayısına eşit veya daha küçük bir no tanımlayınız! ' : null;
    kod=="toast45" ? metin='Lütfen toplam ped motor sayısına eşit veya daha küçük bir no tanımlayınız! ' : null;
    kod=="toast46" ? metin='Lütfen toplam klepe motor sayısına eşit veya daha küçük bir no tanımlayınız! ' : null;
    kod=="toast47" ? metin='Lütfen toplam fan sayısına eşit veya daha küçük bir no tanımlayınız! ' : null;
    kod=="toast48" ? metin='En az bir tane ısıtıcı haritada işaretlenmiş olmalıdır! ' : null;
    kod=="toast49" ? metin='Haritada seçilen ped sayısı, tanımlanandan eksik!' : null;
    kod=="toast50" ? metin='Haritada seçilen ped sayısı, tanımlanandan fazla!' : null;
    kod=="toast51" ? metin='Haritada seçilen ısı sensör sayısı, tanımlanandan eksik!' : null;
    kod=="toast52" ? metin='Haritada seçilen ısı sensör sayısı, tanımlanandan fazla!' : null;
    kod=="toast53" ? metin='En az bir tane baca fanı haritada işaretlenmiş olmalıdır!' : null;
    kod=="toast54" ? metin='Haritada seçilen silo sayısı, tanımlanandan eksik!' : null;
    kod=="toast55" ? metin='Haritada seçilen silo sayısı, tanımlanandan fazla!' : null;
    kod=="toast56" ? metin='Lütfen seçili tüm silolar için sıfırdan farklı silo no tanımlayınız!' : null;
    kod=="toast57" ? metin='Lütfen toplam silo sayısına eşit veya daha küçük bir sayı tanımlayınız!' : null;
    kod=="toast58" ? metin='Aynı Silo No iki farklı silo için tanımlanmış! Lütfen kontrol ediniz' : null;
    kod=="toast59" ? metin='Lütfen aktif tüm çıkışlar için sıfırdan farklı bir çıkış no tanımlayınız!' : null;
    kod=="toast60" ? metin='Isı sensör için wifi bağlantı seçildi.' : null;
    kod=="toast61" ? metin='Isı sensör için Analog bağlantı seçildi.' : null;
    kod=="toast62" ? metin='Önce haritayı oluşturup onaylamanız gerekli!' : null;
    kod=="toast63" ? metin='Lütfen sıfırdan farklı B.fan Grup Çıkış No tanımlayınız!' : null;
    kod=="toast64" ? metin='Kurulum başarıyla tamamlandı...' : null;
    kod=="toast65" ? metin='Civciv ve Broyler kafeslerinde aktif değildir.' : null;
    kod=="toast66" ? metin='Baca fanı olmayan Civciv veya Broyler kafeslerinde PID kontrol aktif değildir.' : null;
    kod=="toast67" ? metin='Sadece bacafanı olmayan Tavuk kafesleri için aktiftir.' : null;
    


    //endregion



    //region Information metinleri


    //TF mod: Lineer , Kafes tipi:Tavuk,  Bacafan: Var
    kod=="info1" ? metin='Kümes içi ortalama sıcaklık (B) değerinin altında ise Minimum Hav. modu, (B) ve (C) değeri arasında'
    ' ise Çapraz Hav. modu, (C) değerinin üstünde ise Tünel Hav. modu etkindir\n\n'
    'Minimum Havalandırma:\n'
    'Minimum Hav. işlemi baca fanları aracılığıyla yapılır. (A) ve (B) değerleri arasında baca fanları sürekli olarak çalışır.'
    ' (A) değerinin altında ise seçili Minimum Hav. yöntemi sonucunda çalışma ve durma süreleri hesaplanır ve baca fanları fasılalı olarak çalışır.\n\n'
    'Çapraz Havalandırma:\n'
    'Çapraz Hav. Tünel Havalandırma modu ile Minimum Havalandırma modunun aynı anda aktif olduğu moddur.'
    ' Çalışan tünel fanı sayısı (B) değerinden (H) değerine gidildikçe lineer olarak artar ve (H) değerinde maksimum kapasiteye ulaşır. (B) ve (C) değerleri '
    ' arasında tünel fanları ile birlikte baca fanları da sürekli olarak çalışır.\n\n'
    'Tünel Havalandırma:\n'
    'Çalışan tünel fanı sayısı (B) değerinden (H) değerine gidildikçe lineer olarak artar ve (H) değerinde maksimum kapasiteye ulaşır.'
    'Tünel fanları ile baca fanlarının birlikte çalıştığı çapraz havalandırma modu (C) değerinde sonlanır ve (C) değerinin üstünde'
    ' sadece tünel fanları devrede olur.\n\n\n' : null;

    //TF mod: Lineer , Kafes tipi:CivBro,  Bacafan: Var
    kod=="info2" ? metin='Kümes içi ortalama sıcaklık (A+B) değerinin altında ise Minimum Hav. modu, (A+B) ve (A+C) değeri arasında'
    ' ise Çapraz Hav. modu, (A+C) değerinin üstünde ise Tünel Hav. modu etkindir\n\n'
    'Minimum Havalandırma:\n'
    'Minimum Hav. işlemi baca fanları aracılığıyla yapılır. (A) ve (A+B) değerleri arasında baca fanları sürekli olarak çalışır.'
    ' (A) değerinin altında ise seçili Minimum Hav. yöntemi sonucunda çalışma ve durma süreleri hesaplanır ve baca fanları fasılalı olarak çalışır.\n\n'
    'Çapraz Havalandırma:\n'
    'Çapraz Hav. Tünel Havalandırma modu ile Minimum Havalandırma modunun aynı anda aktif olduğu moddur.'
    ' Çalışan tünel fanı sayısı (A+B) değerinden (H) değerine gidildikçe lineer olarak artar ve (H) değerinde maksimum kapasiteye ulaşır. (A+B) ve (A+C) değerleri '
    ' arasında tünel fanları ile birlikte baca fanları da sürekli olarak çalışır.\n\n'
    'Tünel Havalandırma:\n'
    'Çalışan tünel fanı sayısı (A+B) değerinden (H) değerine gidildikçe lineer olarak artar ve (H) değerinde maksimum kapasiteye ulaşır.'
    'Tünel fanları ile baca fanlarının birlikte çalıştığı çapraz havalandırma modu (A+C) değerinde sonlanır ve (A+C) değerinin üstünde'
    ' sadece tünel fanları devrede olur.\n\n\n' : null;

    //TF mod: Lineer , Kafes tipi:Tavuk,  Bacafan: Yok
    kod=="info3" ? metin='Kümes içi ortalama sıcaklık (B) değerinin altında ise Minimum Hav. modu, (B) değerinin üstünde ise Tünel Hav. modu etkindir\n\n'
    'Minimum Havalandırma:\n'
    'Minimum Hav. işlemi seçilen birkaç tünel fanı aracılığıyla yapılır. (A) ve (B) değerleri arasında minimum havalandırma için seçilen tünel fanları sürekli olarak çalışır.'
    ' (A) değerinin altında ise seçili Minimum Hav. yöntemi sonucunda çalışma ve durma süreleri hesaplanır ve minimum havalandırma için seçilen tünel fanları fasılalı olarak çalışır.\n\n'
    'Tünel Havalandırma:\n'
    'Çalışan tünel fanı sayısı (B) değerinden (H) değerine gidildikçe lineer olarak artar ve (H) değerinde tüm tünel fanları devreye girmiş olur.\n\n\n': null;

    //TF mod: Lineer , Kafes tipi:CivBro,  Bacafan: Yok
    kod=="info4" ? metin='Kümes içi ortalama sıcaklık (A+B) değerinin altında ise Minimum Hav. modu, (A+B) değerinin üstünde ise Tünel Hav. modu etkindir\n\n'
    'Minimum Havalandırma:\n'
    'Minimum Hav. işlemi seçilen birkaç tünel fanı aracılığıyla yapılır. (A) ve (A+B) değerleri arasında minimum havalandırma için seçilen tünel fanları sürekli olarak çalışır.'
    ' (A) değerinin altında ise seçili Minimum Hav. yöntemi sonucunda çalışma ve durma süreleri hesaplanır ve minimum havalandırma için seçilen tünel fanları fasılalı olarak çalışır.\n\n'
    'Tünel Havalandırma:\n'
    'Çalışan tünel fanı sayısı (A+B) değerinden (H) değerine gidildikçe lineer olarak artar ve (H) değerinde tüm tünel fanları devreye girmiş olur.\n\n\n': null;






    //TF mod: Klasik , Kafes tipi:Tavuk,  Bacafan: Yok
    kod=="info5" ? metin='Kümes içi ortalama sıcaklık (B) değerinin altında ise Minimum Hav. modu, (B) değerinin üstünde ise Tünel Hav. modu etkindir\n\n'
    'Minimum Havalandırma:\n'
    'Minimum Hav. işlemi seçilen birkaç tünel fanı aracılığıyla yapılır. (A) ve (B) değerleri arasında minimum havalandırma için seçilen tünel fanları sürekli olarak çalışır.'
    ' (A) değerinin altında ise seçili Minimum Hav. yöntemi sonucunda çalışma ve durma süreleri hesaplanır ve minimum havalandırma için seçilen tünel fanları fasılalı olarak çalışır.\n\n'
    'Tünel Havalandırma:\n'
    'Tüm tünel fanları için (B) noktası ve üstünde olacak şekilde ayrı ayrı set değeri'
    ' tanımlanır. Ortalama sıcaklık tanımlanan bu değerin üstüne çıktığında ilgili tünel fanı çalışır, altına indiğinde durur.\n\n\n': null;

    //TF mod: Klasik , Kafes tipi:Tavuk,  Bacafan: Var
    kod=="info6" ? metin='Kümes içi ortalama sıcaklık (B) değerinin altında ise Minimum Hav. modu, (B) ve (C) değeri arasında'
    ' ise Çapraz Hav. modu, (C) değerinin üstünde ise Tünel Hav. modu etkindir\n\n'
    'Minimum Havalandırma:\n'
    'Minimum Hav. işlemi baca fanları aracılığıyla yapılır. (A) ve (B) değerleri arasında baca fanları sürekli olarak çalışır.'
    ' (A) değerinin altında ise seçili Minimum Hav. yöntemi sonucunda çalışma ve durma süreleri hesaplanır ve baca fanları fasılalı olarak çalışır.\n\n'
    'Çapraz Havalandırma:\n'
    'Çapraz Hav. Tünel Havalandırma modu ile Minimum Havalandırma modunun aynı anda aktif olduğu moddur. Bu sistemde tüm tünel fanları için (B) noktası'
    ' ve üstünde ayrı ayrı set değeri tanımlanır. Ortalama sıcaklık tanımlanan bu değerin üstüne çıktığında ilgili tünel fanı çalışır, altına indiğinde durur.'
    ' (B) ve (C) değerleri arasında tünel fanları ile birlikte baca fanları da sürekli olarak çalışır.\n\n'
    'Tünel Havalandırma:\n'
    'Bu sistemde tüm tünel fanları için (B) noktası ve üstünde ayrı ayrı set değeri'
    ' tanımlanır. Ortalama sıcaklık tanımlanan bu değerin üstüne çıktığında ilgili tünel fanı çalışır, altına indiğinde durur.'
    ' Tünel fanları ile baca fanlarının birlikte çalıştığı çapraz havalandırma modu (C) değerinde sonlanır ve (C) değerinin üstünde'
    ' sadece tünel fanları devrede olur.\n\n\n' : null;








    //TF mod: PID , Kafes tipi:Tavuk,  Bacafan: Yok
    kod=="info7" ? metin='Kümes içi ortalama sıcaklık (A) değerinin altında ise Minimum Hav. modu, (A) değerinin üstünde ise Tünel Hav. modu etkindir\n\n'
    'Minimum Havalandırma:\n'
    'Minimum Hav. işlemi seçilen birkaç tünel fanı aracılığıyla yapılır. Ortalama sıcaklık (A) değerinin altında ise seçili Minimum Hav. yöntemi sonucunda çalışma ve durma'
    'süreleri hesaplanır ve minimum havalandırma için seçilen tünel fanları fasılalı olarak çalışır.\n\n'
    'Tünel Havalandırma:\n'
    ' PID kontrol yönteminde ortalama sıcaklık (A) noktası ve üstünde ise PLC ortam sıcaklığının ısınma ve soğuma'
    ' hızlarını algılar, bu hızları kontrol edebilecek yeterlilikte tünel fan sayısını hesaplar ve devreye sokar.': null;


    //TF mod: PID , Kafes tipi:Tavuk,  Bacafan: Var
    kod=="info8" ? metin='Kümes içi ortalama sıcaklık (A) değerinin altında ise Minimum Hav. modu, (A) ve (C) değeri arasında'
    ' ise Çapraz Hav. modu, (C) değerinin üstünde ise Tünel Hav. modu etkindir\n\n'
    'Minimum Havalandırma:\n'
    'Minimum Hav. işlemi baca fanları aracılığıyla yapılır. Ortalama sıcaklık (A) değerinin altında ise seçili Minimum Hav. yöntemi sonucunda çalışma ve durma'
    ' süreleri hesaplanır ve baca fanları fasılalı olarak çalışır.\n\n'
    'Çapraz Hav. Tünel Havalandırma modu ile Minimum Havalandırma modunun aynı anda aktif olduğu moddur.'
    ' (A) ve (C) değerleri arasında tünel fanları ile birlikte baca fanları da sürekli olarak çalışır.\n\n'
    'Tünel Havalandırma:\n'
    ' PID kontrol yönteminde ortalama sıcaklık (A) noktası ve üstünde ise PLC ortam sıcaklığının ısınma ve soğuma'
    ' hızlarını algılar, bu hızları kontrol edebilecek yeterlilikte tünel fan sayısını hesaplar ve devreye sokar.'
    ' Tünel fanları ile baca fanlarının birlikte çalıştığı çapraz havalandırma modu (C) değerinde sonlanır ve (C) değerinin üstünde'
    ' sadece tünel fanları devrede olur.\n\n\n' : null;

    //TF mod: PID , Kafes tipi:CivBro,  Bacafan: Var
    kod=="info9" ? metin='Kümes içi ortalama sıcaklık (A) değerinin altında ise Minimum Hav. modu, (A) ve (A+C) değeri arasında'
    ' ise Çapraz Hav. modu, (A+C) değerinin üstünde ise Tünel Hav. modu etkindir\n\n'
    'Minimum Havalandırma:\n'
    'Minimum Hav. işlemi baca fanları aracılığıyla yapılır. Ortalama sıcaklık (A) değerinin altında ise seçili Minimum Hav. yöntemi sonucunda çalışma ve durma'
    ' süreleri hesaplanır ve baca fanları fasılalı olarak çalışır.\n\n'
    'Çapraz Hav. Tünel Havalandırma modu ile Minimum Havalandırma modunun aynı anda aktif olduğu moddur.'
    ' (A) ve (A+C) değerleri arasında tünel fanları ile birlikte baca fanları da sürekli olarak çalışır.\n\n'
    'Tünel Havalandırma:\n'
    ' PID kontrol yönteminde ortalama sıcaklık (A) noktası ve üstünde ise PLC ortam sıcaklığının ısınma ve soğuma'
    ' hızlarını algılar, bu hızları kontrol edebilecek yeterlilikte tünel fan sayısını hesaplar ve devreye sokar.'
    ' Tünel fanları ile baca fanlarının birlikte çalıştığı çapraz havalandırma modu (A+C) değerinde sonlanır ve (A+C) değerinin üstünde'
    ' sadece tünel fanları devrede olur.\n\n\n' : null;



    //endregion


    return metin;
  }


  languageEN(String kod){

    String metin="0kod";

    kod=='slogan' ? metin='Programmable Poultry Air Conditioning System' : null;

    kod=='pdiag1' ? metin='Checking…' : null;
    kod=='cbox2' ? metin='Receive setup installation' : null;

    //region TEXTVIEW
    
    kod=="tv1" ? metin='Choosing Language' : null;
    kod=="tv2" ? metin='Basic Settings' : null;
    kod=="tv3" ? metin='Cage Type' : null;
    kod=="tv4" ? metin='Cage No' : null;
    kod=="tv5" ? metin='Cage Name' : null;
    kod=="tv6" ? metin='Click here for cage name…' : null;
    kod=="tv7" ? metin='Define admin password…' : null;
    kod=="tv8" ? metin='Admin Password' : null;
    kod=="tv9" ? metin='Verify the password…' : null;
    kod=="tv10" ? metin='Admin Password Again' : null;
    kod=="tv11" ? metin='Control Element Numbers' : null;
    kod=="tv12" ? metin='Fan Number' : null;
    kod=="tv13" ? metin='Klepe Number' : null;
    kod=="tv14" ? metin='Ped Pump Number' : null;
    kod=="tv15" ? metin='Temp. Sens. Number' : null;
    kod=="tv16" ? metin='Chimney F. Group Number' : null;
    kod=="tv17" ? metin='A.Inlet M.Number' : null;
    kod=="tv18" ? metin='Heater Number' : null;
    kod=="tv19" ? metin='Silo Number' : null;
    kod=="tv20" ? metin='Fan Control Method' : null;
    kod=="tv21" ? metin='Clasic Control' : null;
    kod=="tv22" ? metin='Linear Control' : null;
    kod=="tv23" ? metin='PID Control' : null;
    kod=="tv24" ? metin='Min. Vent. Control Method' : null;
    kod=="tv25" ? metin='Weight Control' : null;
    kod=="tv26" ? metin='Volume Control' : null;
    kod=="tv27" ? metin='Klepe Control Method' : null;
    kod=="tv28" ? metin='Tunnel Control' : null;
    kod=="tv29" ? metin='Dimensions, Out Humidity and Flow' : null;
    kod=="tv30" ? metin='Out Hum' : null;
    kod=="tv31" ? metin='Fan Map' : null;
    kod=="tv32" ? metin='Fan:' : null;
    kod=="tv33" ? metin='Out:' : null;
    kod=="tv34" ? metin='FAN NO' : null;
    kod=="tv35" ? metin='OUT NO' : null;
    kod=="tv36" ? metin='Password match :' : null;
    kod=="tv37" ? metin='The map will reset! Are you sure?' : null;
    kod=="tv38" ? metin='Klepe Map' : null;
    kod=="tv39" ? metin='Klp:' : null;
    kod=="tv40" ? metin='KLEPE NO' : null;
    kod=="tv41" ? metin='OP. OUT NO' : null;
    kod=="tv42" ? metin='CL. OUT NO' : null;
    kod=="tv43" ? metin='OutOp:' : null;
    kod=="tv44" ? metin='OutCl:' : null;
    kod=="tv45" ? metin='Ped:' : null;
    kod=="tv46" ? metin='PED NO' : null;
    kod=="tv47" ? metin='Ped Pump Map' : null;
    kod=="tv48" ? metin='Temp. Sensor Map' : null;
    kod=="tv49" ? metin='TEMPSens NO' : null;
    kod=="tv50" ? metin='Sens:' : null;
    kod=="tv51" ? metin='Registered Sensors' : null;
    kod=="tv52" ? metin='Sens. No:' : null;
    kod=="tv53" ? metin='Front Wall' : null;
    kod=="tv54" ? metin='Right Wall' : null;
    kod=="tv55" ? metin='Back Wall' : null;
    kod=="tv56" ? metin='Left Wall' : null;
    kod=="tv57" ? metin='Build Top Preview' : null;
    kod=="tv58" ? metin='Front' : null;
    kod=="tv59" ? metin='Back' : null;
    kod=="tv60" ? metin='There is no active sensor that connected to system...' : null;
    kod=="tv61" ? metin='TEMPSens NO Sign' : null;
    kod=="tv62" ? metin='OUTPUTS' : null;
    kod=="tv63" ? metin='Group:' : null;
    kod=="tv64" ? metin='Cfan Group No' : null;
    kod=="tv65" ? metin='C.Fan Gr-1 Out No' : null;
    kod=="tv66" ? metin='C.Fan Gr-2 Out No' : null;
    kod=="tv67" ? metin='C.Fan Gr-3 Out No' : null;
    kod=="tv68" ? metin='Chimney Fan Map' : null;
    kod=="tv69" ? metin='Cfan Group Out No' : null;
    kod=="tv70" ? metin='Out Temp. Sen.' : null;
    kod=="tv71" ? metin='Air Inlet Map' : null;
    kod=="tv72" ? metin='No:' : null;
    kod=="tv73" ? metin='Out:' : null;
    kod=="tv74" ? metin='A.INLET NO' : null;
    kod=="tv75" ? metin='Air:' : null;
    kod=="tv76" ? metin='Heater Map' : null;
    kod=="tv77" ? metin='Heater Gr-1 Out No' : null;
    kod=="tv78" ? metin='Heater Gr-2 Out No' : null;
    kod=="tv79" ? metin='Heater Gr-3 Out No' : null;
    kod=="tv80" ? metin='Heater Group No' : null;
    kod=="tv81" ? metin='Boşta' : null;
    kod=="tv82" ? metin='Silo:' : null;
    kod=="tv83" ? metin='SILO' : null;
    kod=="tv84" ? metin='Silo Map' : null;
    kod=="tv85" ? metin='Other Outputs' : null;
    kod=="tv86" ? metin='ALARM' : null;
    kod=="tv87" ? metin='WARNING' : null;
    kod=="tv88" ? metin='LIGHT' : null;
    kod=="tv89" ? metin='Feed 1 Forward' : null;
    kod=="tv90" ? metin='Feed 2 Forward' : null;
    kod=="tv91" ? metin='Feed 3 Forward' : null;
    kod=="tv92" ? metin='Feed 1 Back' : null;
    kod=="tv93" ? metin='Feed 2 Back' : null;
    kod=="tv94" ? metin='Feed 3 Back' : null;
    kod=="tv95" ? metin='Feed 1 Active' : null;
    kod=="tv96" ? metin='Feed 2 Active' : null;
    kod=="tv97" ? metin='Feed 3 Active' : null;
    kod=="tv98" ? metin='Complete Installation' : null;
    kod=="tv99" ? metin='GENERAL SETTING' : null;
    kod=="tv100" ? metin='WATCH' : null;
    kod=="tv101" ? metin='OTO-MAN' : null;
    kod=="tv102" ? metin='CONTROL' : null;
    kod=="tv103" ? metin='DATA LOG' : null;
    kod=="tv104" ? metin='ALARM SET.' : null;
    kod=="tv105" ? metin='INSTALLATION' : null;
    kod=="tv106" ? metin='CONTROL SETTINGS' : null;
    kod=="tv107" ? metin='TEMP. and HUM.' : null;
    kod=="tv108" ? metin='KLEPE' : null;
    kod=="tv109" ? metin='COOLING' : null;
    kod=="tv110" ? metin='MIN. VENT.' : null;
    kod=="tv111" ? metin='HEATER' : null;
    kod=="tv112" ? metin='LIGHTING' : null;
    kod=="tv113" ? metin='SILO and FEED' : null;
    kod=="tv114" ? metin='P. WIZARD' : null;
    kod=="tv115" ? metin='Set temperature' : null;
    kod=="tv116" ? metin='Tunnel vent. start temp.' : null;
    kod=="tv117" ? metin='Cross vent. finish temp.' : null;
    kod=="tv118" ? metin='Tunnel vent. active area' : null;
    kod=="tv119" ? metin='Cross vent. active area' : null;
    kod=="tv120" ? metin='Min vent. active area(cont)' : null;
    kod=="tv121" ? metin='Min vent. active area(int)' : null;
    kod=="tv122" ? metin='Maks. fan sıcaklığı' : null;
    kod=="tv123" ? metin='Temperature Diagram' : null;
    kod=="tv124" ? metin='Navigator Menu' : null;

    

    
    

    //endregion

    //region BUTTON

    kod=="btn1" ? metin='APPROVE' : null;
    kod=="btn2" ? metin='OKEY' : null;
    kod=="btn3" ? metin='EXIT' : null;
    kod=="btn4" ? metin='Approve Map' : null;
    kod=="btn5" ? metin='Reset Map' : null;
    kod=="btn6" ? metin='Send Data' : null;
    kod=="btn7" ? metin='YES' : null;
    kod=="btn8" ? metin='NO' : null;
    

    //endregion

    //region TEXTFIELD LABEL

    kod=="tflb1" ? metin='Tun. Fan Flow' : null;
    kod=="tflb2" ? metin='Chm. F. Flow' : null;
    kod=="tflb3" ? metin='Volume Ratio(%)' : null;


    kod=="tfhp1" ? metin='(m3/h)' : null;
    
    
    //endregion

    //region DROPDOWN LIST

    kod=="dd1" ? metin='LAYER' : null;
    kod=="dd2" ? metin='REARING' : null;
    kod=="dd3" ? metin='BROILER' : null;
    

    //endregion

    //region HINT

    kod=="hint1" ? metin='Cage Name' : null;

    //endregion

    //region TOAST

    kod=="toast1" ? metin='Plase use atleast 4 character for cage name' : null;
    kod=="toast2" ? metin='Plase define password as 4-digit number' : null;
    kod=="toast3" ? metin='The passwords do not match' : null;
    kod=="toast4" ? metin='One of Fan Control Method must be selected!' : null;
    kod=="toast5" ? metin='You entered bigger than defined klepe number.Please check again!' : null;
    kod=="toast6" ? metin='One of Klepe no , X(m), Y(m) values or more are empty!' : null;
    kod=="toast7" ? metin='Invalid entry for x(m) or Y(m) value! Please check.' : null;
    kod=="toast8" ? metin='Successful' : null;
    kod=="toast9" ? metin='One or more Klepes dimensions must be defined!' : null;
    kod=="toast10" ? metin='One of A(m), B(m), C(m) values or more are empty!' : null;
    kod=="toast11" ? metin='One of Tunnel Fan Flow, Chimney F. Flow values or both are empty!' : null;
    kod=="toast12" ? metin='Volume Ratio value is empty!' : null;
    kod=="toast13" ? metin='One of A(m), B(m), C(m) values or more are invalid!' : null;
    kod=="toast14" ? metin='One of Tunnel Fan Flow, Chimney F. Flow values or both are invalid!' : null;
    kod=="toast15" ? metin='Volume Ratio value is invalid!' : null;
    kod=="toast16" ? metin='Number of selected fans are less then the defined!' : null;
    kod=="toast17" ? metin='Fans and walls that defined must form a rectangle!' : null;
    kod=="toast18" ? metin='Number of selected fans are more then the defined!' : null;
    kod=="toast19" ? metin='You must approve the password that you defined!' : null;
    kod=="toast20" ? metin='Connection failed!' : null;
    kod=="toast21" ? metin='New password approved' : null;
    kod=="toast22" ? metin='One of Min. Vent. Control Method must be selected!' : null;
    kod=="toast23" ? metin='One of Klepe Control Method must be selected!' : null;
    kod=="toast24" ? metin='Please define Fan Number and Output number as nonzero for all selected fans' : null;
    kod=="toast25" ? metin='Same Fan Number assigned for two different fan! Please check.' : null;
    kod=="toast26" ? metin='Same Out Number assigned for two different out! Please check.' : null;
    kod=="toast27" ? metin='Please firstly send defined data!' : null;
    kod=="toast28" ? metin='Same Klepe Number assigned for two different klepe! Please check.' : null;
    kod=="toast29" ? metin='Number of selected klepes are less then the defined!' : null;
    kod=="toast30" ? metin='Number of selected klepes are more then the defined!' : null;
    kod=="toast31" ? metin='Same Temp. Sensor Number assigned for two different temp. sensor! Please check.' : null;
    kod=="toast32" ? metin='Same Ped Number assigned for two different ped! Please check.' : null;
    kod=="toast33" ? metin='Two of active sensors assigned same number! Please check.' : null;
    kod=="toast34" ? metin='Atleast one active sensor must be assigned!' : null;
    kod=="toast35" ? metin='Please define Temp. Sensor Number as nonzero for all selected temp sensors' : null;
    kod=="toast36" ? metin='Please define Ped Number and Output number as nonzero for all selected peds' : null;
    kod=="toast37" ? metin='Please define Klepe Number and Output number as nonzero for all selected klepes' : null;
    kod=="toast38" ? metin='One of target outputs in use! Please release first the target output' : null;
    kod=="toast39" ? metin='Please define Chimney Fan Grup Number as nonzero for all selected chimney fans on the map' : null;
    kod=="toast40" ? metin='Please define a number equal or smaller than total sensor quantity' : null;
    kod=="toast41" ? metin='Selected sensor number is not define on the map!' : null;
    kod=="toast42" ? metin='Same Air Inlet Number assigned for two different air inlet! Please check.' : null;
    kod=="toast43" ? metin='Please define a number equal or smaller than total chimney fan grup quantity' : null;
    kod=="toast44" ? metin='Please define a number equal or smaller than total air inlet motor quantity' : null;
    kod=="toast45" ? metin='Please define a number equal or smaller than total ped motor quantity' : null;
    kod=="toast46" ? metin='Please define a number equal or smaller than total klepe motor quantity' : null;
    kod=="toast47" ? metin='Please define a number equal or smaller than total fan quantity' : null;
    kod=="toast48" ? metin='Atleast one heater must be selected on the map! ' : null;
    kod=="toast49" ? metin='Number of selected peds are less then the defined!' : null;
    kod=="toast50" ? metin='Number of selected peds are more then the defined!' : null;
    kod=="toast51" ? metin='Number of selected temp. sensors are less then the defined!' : null;
    kod=="toast52" ? metin='Number of selected temp. sensors are more then the defined!' : null;
    kod=="toast53" ? metin='Atleast one chimney fan must be selected on the map! ' : null;
    kod=="toast54" ? metin='Number of selected silo are less then the defined!' : null;
    kod=="toast55" ? metin='Number of selected silo are more then the defined!' : null;
    kod=="toast56" ? metin='Please define Silo Number as nonzero for all selected temp silos' : null;
    kod=="toast57" ? metin='Please define a number equal or smaller than total silo quantity' : null;
    kod=="toast58" ? metin='Same Silo Number assigned for two different silo! Please check.' : null;
    kod=="toast59" ? metin='Please define output number as nonzero for all active outputs!' : null;
    kod=="toast60" ? metin='Wifi connection is selected for temp. sensor' : null;
    kod=="toast61" ? metin='Analog connection is selected for temp. sensor' : null;
    kod=="toast62" ? metin='The map must be created and approved!' : null;
    kod=="toast63" ? metin='Please define C.Fan Group Output No as nonzero' : null;
    kod=="toast64" ? metin='Installation completed succesfully...' : null;
    kod=="toast65" ? metin='It is passive for Rearing and Broiler Cages.' : null;
    kod=="toast66" ? metin='PID Control Method is passive for Rearing and Broiler Cages which have not chimney fans.' : null;
    kod=="toast67" ? metin='Only active for Layer Cages which have not chimney fans.' : null;


    //endregion

    return metin;
  }


}