

class Dil{

  sec(String dilSecimi, String kod){

    String metin="";
    dilSecimi == 'TR' ? metin = languageTR(kod) : metin = languageEN(kod) ;

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
    kod=="tv29" ? metin='Bina, Dış Nem ve Debi' : null;
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
    kod=="tv86" ? metin='ALARM ÇKŞ' : null;
    kod=="tv87" ? metin='UYARI ÇKŞ' : null;
    kod=="tv88" ? metin='AYD. ÇKŞ' : null;
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
    kod=="tv105" ? metin='SİSTEM' : null;
    kod=="tv106" ? metin='KONTROL AYARLARI' : null;
    kod=="tv107" ? metin='SIC. & FAN' : null;
    kod=="tv108" ? metin='KLEPE' : null;
    kod=="tv109" ? metin='SOĞ. & NEM' : null;
    kod=="tv110" ? metin='MİN. HAV.' : null;
    kod=="tv111" ? metin='ISITMA' : null;
    kod=="tv112" ? metin='AYDINLATMA' : null;
    kod=="tv113" ? metin='YEM & SU' : null;
    kod=="tv114" ? metin='YARD. OPS.' : null;
    kod=="tv115" ? metin='Set Sıcaklığı' : null;
    kod=="tv116" ? metin='Doğal bölge bitiş sıcaklığı' : null;
    kod=="tv117" ? metin='Çapraz hav. bitiş sıcaklığı' : null;
    kod=="tv118" ? metin='Tünel hav. aktif alan' : null;
    kod=="tv119" ? metin='Çapraz hav. aktif alan' : null;
    kod=="tv120" ? metin='Doğ.Bölge-Min.Hav. Sürekli' : null;
    kod=="tv121" ? metin='Min.Hav. Fasılalı' : null;
    kod=="tv122" ? metin='Maks. fan sıcaklığı' : null;
    kod=="tv123" ? metin='Sıcaklık Diyagramı' : null;
    kod=="tv124" ? metin='Navigatör Menü' : null;
    kod=="tv125" ? metin='Set Sıcaklığı (A)' : null;
    kod=="tv126" ? metin='Doğal Bölge Farkı (B)' : null;
    kod=="tv127" ? metin='FANLARIN SET SICAKLIKLARI (°C)' : null;
    kod=="tv128" ? metin='Çapraz Hav. Farkı (C)' : null;
    kod=="tv129" ? metin='Bosta' : null;
    kod=="tv130" ? metin='Maks. Fan Farkı (H)' : null;
    kod=="tv131" ? metin='Gün 1: ' : null;
    kod=="tv132" ? metin='Gün 2: ' : null;
    kod=="tv133" ? metin='Gün 3: ' : null;
    kod=="tv134" ? metin='Gün 4: ' : null;
    kod=="tv135" ? metin='Gün 5: ' : null;
    kod=="tv136" ? metin='Gün 6: ' : null;
    kod=="tv137" ? metin='Gün 7: ' : null;
    kod=="tv138" ? metin='Gün 8: ' : null;
    kod=="tv139" ? metin='Gün 9: ' : null;
    kod=="tv140" ? metin='Gün 10: ' : null;
    kod=="tv141" ? metin='Gün 11: ' : null;
    kod=="tv142" ? metin='Gün 12: ' : null;
    kod=="tv143" ? metin='Gün 13: ' : null;
    kod=="tv144" ? metin='Gün 14: ' : null;
    kod=="tv145" ? metin='Gün 15: ' : null;
    kod=="tv146" ? metin='Gün 16: ' : null;
    kod=="tv147" ? metin='Gün 17: ' : null;
    kod=="tv148" ? metin='Gün 18: ' : null;
    kod=="tv149" ? metin='Gün 19: ' : null;
    kod=="tv150" ? metin='Gün 20: ' : null;
    kod=="tv151" ? metin='Gün 21: ' : null;
    kod=="tv152" ? metin='Gün 22: ' : null;
    kod=="tv153" ? metin='Gün 23: ' : null;
    kod=="tv154" ? metin='Gün 24: ' : null;
    kod=="tv155" ? metin='Gün 25: ' : null;
    kod=="tv156" ? metin='Gün 26: ' : null;
    kod=="tv157" ? metin='Gün 27: ' : null;
    kod=="tv158" ? metin='Gün 28: ' : null;
    kod=="tv159" ? metin='Gün 29: ' : null;
    kod=="tv160" ? metin='Gün 30: ' : null;
    kod=="tv161" ? metin='Gün 31: ' : null;
    kod=="tv162" ? metin='Gün 32: ' : null;
    kod=="tv163" ? metin='Gün 33: ' : null;
    kod=="tv164" ? metin='Gün 34: ' : null;
    kod=="tv165" ? metin='Gün 35: ' : null;
    kod=="tv166" ? metin='Gün 36: ' : null;
    kod=="tv167" ? metin='Gün 37: ' : null;
    kod=="tv168" ? metin='Gün 38: ' : null;
    kod=="tv169" ? metin='Gün 39: ' : null;
    kod=="tv170" ? metin='Gün 40: ' : null;
    kod=="tv171" ? metin='Gün 41: ' : null;
    kod=="tv172" ? metin='Gün 42: ' : null;
    kod=="tv173" ? metin='1. Gün' : null;
    kod=="tv174" ? metin='7. Gün' : null;
    kod=="tv175" ? metin='14. Gün' : null;
    kod=="tv176" ? metin='21. Gün' : null;
    kod=="tv177" ? metin='28. Gün' : null;
    kod=="tv178" ? metin='35. Gün' : null;
    kod=="tv179" ? metin='42. Gün' : null;
    kod=="tv180" ? metin='7 HAFTALIK SET SICAKLIK TANIMLAMASI' : null;
    kod=="tv181" ? metin='SICAKLIK SET ve FAN' : null;
    kod=="tv182" ? metin='Fan Kademesi' : null;
    kod=="tv183" ? metin='Sıc. Doğrusu(°C)' : null;
    kod=="tv184" ? metin='Sıcaklık Çizelgesi' : null;
    kod=="tv185" ? metin='Fanların Set Sıc.' : null;
    kod=="tv186" ? metin='Açıklama' : null;
    kod=="tv187" ? metin='Doğ. Böl.' : null;
    kod=="tv188" ? metin='Set Sıc.' : null;
    kod=="tv189" ? metin='Çapr. Hav.' : null;
    kod=="tv190" ? metin='Tün. Hav.' : null;
    kod=="tv191" ? metin='PID Set Kaydırma' : null;
    kod=="tv192" ? metin='KLEPE' : null;
    kod=="tv193" ? metin='Fan - Klepe Diyagramı' : null;
    kod=="tv194" ? metin='Aktüel Açıklık :' : null;
    kod=="tv195" ? metin='Çalışan Fan Say. 1-2 :' : null;
    kod=="tv196" ? metin='Klepe Açıklık 1-2 :' : null;
    kod=="tv197" ? metin='Çalışan Fan Say. 3-4 :' : null;
    kod=="tv198" ? metin='Klepe Açıklık 3-4 :' : null;
    kod=="tv199" ? metin='Min.Hav. Açıklık :' : null;
    kod=="tv200" ? metin='Çalışan Fan Say. 1' : null;
    kod=="tv201" ? metin='Çalışan Fan Say. 2' : null;
    kod=="tv202" ? metin='Çalışan Fan Say. 3' : null;
    kod=="tv203" ? metin='Çalışan Fan Say. 4' : null;
    kod=="tv204" ? metin='Klepe Açıklık 1' : null;
    kod=="tv205" ? metin='Klepe Açıklık 2' : null;
    kod=="tv206" ? metin='Klepe Açıklık 3' : null;
    kod=="tv207" ? metin='Klepe Açıklık 4' : null;
    kod=="tv208" ? metin='Senaryo 1' : null;
    kod=="tv209" ? metin='Senaryo 2' : null;
    kod=="tv210" ? metin='Çalışan Fan Sayısı' : null;
    kod=="tv211" ? metin='Klepe Açıklık oranı' : null;
    kod=="tv212" ? metin='AÇIKLIK PARAMETRELERİ - ' : null;
    kod=="tv213" ? metin='Klp Baş. Düş. Fan Mik. :' : null;
    kod=="tv214" ? metin='Klp Baş. Düş. Fan Modu :' : null;
    kod=="tv215" ? metin='Çalışma Sırası :' : null;
    kod=="tv216" ? metin='Min-Maks. Açıklık :' : null;
    kod=="tv217" ? metin='Klp Baş. Düşen\nFan Mik. Man' : null;
    kod=="tv218" ? metin='Maks. Açıklık :' : null;
    kod=="tv219" ? metin='Min. Açıklık :' : null;
    kod=="tv220" ? metin='Oto' : null;
    kod=="tv221" ? metin='Man' : null;
    kod=="tv222" ? metin='Klp Baş. Düşen\nFan Sayısını Manuel Gir' : null;
    kod=="tv223" ? metin='Sıra1 Fan Say. Bitiş' : null;
    kod=="tv224" ? metin='Sıra2 Fan Say. Bitiş' : null;
    kod=="tv225" ? metin='Sıra 1 Min. Açıklık' : null;
    kod=="tv226" ? metin='Sıra 1 Maks. Açıklık' : null;
    kod=="tv227" ? metin='Sıra 2 Min. Açıklık' : null;
    kod=="tv228" ? metin='Sıra 2 Maks. Açıklık' : null;
    kod=="tv229" ? metin='Çalışma Sırası 1' : null;
    kod=="tv230" ? metin='Çalışma Sırası 2' : null;
    kod=="tv231" ? metin='Sıra2 Fan Say. Başl' : null;
    kod=="tv232" ? metin='Kalibrasyon\nBaşlat' : null;
    kod=="tv233" ? metin='Kalibrasyon Durumu :' : null;
    kod=="tv234" ? metin='Kalibrasyon Süresi :' : null;
    kod=="tv235" ? metin='Klp Oto-Man Durum :' : null;
    kod=="tv236" ? metin='Aktif' : null;
    kod=="tv237" ? metin='Pasif' : null;
    kod=="tv238" ? metin='Sn' : null;
    kod=="tv239" ? metin='KLEPE KALİBRASYON' : null;
    kod=="tv240" ? metin='Kalibrasyon Detayları' : null;
    kod=="tv241" ? metin='Klepe\nKalibrasyon' : null;
    kod=="tv242" ? metin='Çalışma Sıcaklığı(A+B) :' : null;
    kod=="tv243" ? metin='Durma Sıcaklığı(A+C) :' : null;
    kod=="tv244" ? metin='PED P.' : null;
    kod=="tv245" ? metin='ÇALIŞMA SICAKLIĞI FARK(B) :' : null;
    kod=="tv246" ? metin='DURMA SICAKLIĞI FARK(C) :' : null;
    kod=="tv247" ? metin='Çalışma Sıc. Fark' : null;
    kod=="tv248" ? metin='Durma Sıc. Fark' : null;
    kod=="tv249" ? metin='SOĞUTMA PED POMPALARI' : null;
    kod=="tv250" ? metin='Maks. Nem' : null;
    kod=="tv251" ? metin='Nem Fark' : null;
    kod=="tv252" ? metin='Maksimum Nem' : null;
    kod=="tv253" ? metin='Soğutma Diyagramı' : null;
    kod=="tv254" ? metin='Çalışma Sıcaklığı' : null;
    kod=="tv255" ? metin='Durma Sıcaklığı' : null;
    kod=="tv256" ? metin='Ped P. Pasif Alan' : null;
    kod=="tv257" ? metin='Ped P. kısmi Aktif Alan' : null;
    kod=="tv258" ? metin='Ped P. Aktif Alan' : null;
    kod=="tv259" ? metin='Maks. Nem Pasif Alan' : null;
    kod=="tv260" ? metin='Maks. Nem kısmi Aktif Alan' : null;
    kod=="tv261" ? metin='Maks. Nem Aktif Alan' : null;
    kod=="tv262" ? metin='ISITICI Gr.' : null;
    kod=="tv263" ? metin='ISITMA' : null;
    kod=="tv264" ? metin='Isıtma Diyagramı' : null;
    kod=="tv265" ? metin='Isıtıcı Aktif Alan' : null;
    kod=="tv266" ? metin='Isıtıcı kısmi Aktif Alan' : null;
    kod=="tv267" ? metin='Isıtıcı Pasif Alan' : null;
    kod=="tv268" ? metin='Çalışma Sıcaklığı(A-B) :' : null;
    kod=="tv269" ? metin='Durma Sıcaklığı(A-C) :' : null;
    kod=="tv270" ? metin='Çalışma Sür.(Sn)' : null;
    kod=="tv271" ? metin='Durma Sür.(Sn)' : null;
    kod=="tv272" ? metin='Fasılada Maks.\nÇalışma Yüzdesi(%)' : null;
    kod=="tv273" ? metin='Air Inlet\nÖncelik Süresi(Sn)' : null;
    kod=="tv274" ? metin='Hava Giriş\nYüzdesi(%)' : null;
    kod=="tv275" ? metin='Fasıla Durma\'da Air Inlet Kapansın mı?' : null;
    kod=="tv276" ? metin='MİNİMUM HAVALANDIRMA' : null;
    kod=="tv277" ? metin='Min. Hav.\nFan Sayısı' : null;
    kod=="tv278" ? metin='Hayv. Başına\nihtiyaç(m3/h)' : null;
    kod=="tv279" ? metin='7 Haftalık Hayvan Başına İhtiyaç(m3/h)' : null;
    kod=="tv280" ? metin='1-7 Gün' : null;
    kod=="tv281" ? metin='8-14 Gün' : null;
    kod=="tv282" ? metin='15-21 Gün' : null;
    kod=="tv283" ? metin='22-28 Gün' : null;
    kod=="tv284" ? metin='29-35 Gün' : null;
    kod=="tv285" ? metin='36-42 Gün' : null;
    kod=="tv286" ? metin='43-49 Gün' : null;
    kod=="tv287" ? metin='50 ve Sonrası' : null;
    kod=="tv288" ? metin='Default Değerlere Dön' : null;
    kod=="tv289" ? metin='Dönemlik Hayvan Başına Hava İhtiyacı(m3/h)' : null;
    kod=="tv290" ? metin='7-20 Hafta' : null;
    kod=="tv291" ? metin='21-52 Hafta' : null;
    kod=="tv292" ? metin='53 ve Sonrası' : null;
    kod=="tv293" ? metin='Min. Hav. Ağırlık Modu' : null;
    kod=="tv294" ? metin='Fasıla Döngü Süresi(dk)' : null;
    kod=="tv295" ? metin='Toplam Aktif\nHacim(m3)' : null;
    kod=="tv296" ? metin='Toplam Aktif Hacim kaç dk\'da yenilensin?' : null;
    kod=="tv297" ? metin='5 dk' : null;
    kod=="tv298" ? metin='10 dk' : null;
    kod=="tv299" ? metin='KURULUM AYARLARI' : null;
    kod=="tv300" ? metin='Admin Şifre' : null;
    kod=="tv301" ? metin='Şifre giriniz...' : null;
    kod=="tv302" ? metin='Adetler' : null;
    kod=="tv303" ? metin='Fan Kon. Yöntemi' : null;
    kod=="tv304" ? metin='MH Kon. Yöntemi' : null;
    kod=="tv305" ? metin='Klp Kon. Yöntemi' : null;
    kod=="tv306" ? metin='Bina,Nem,Debi' : null;
    kod=="tv307" ? metin='Ped P. Haritası' : null;
    kod=="tv308" ? metin='Isı Sen. Haritası' : null;
    kod=="tv309" ? metin='Fasıla Set 1 (C)' : null;
    kod=="tv310" ? metin='Fasıla Set 2 (D)' : null;
    kod=="tv311" ? metin='Fasıla Set 3 (E)' : null;
    kod=="tv312" ? metin='Çalışma Süresi 1' : null;
    kod=="tv313" ? metin='Çalışma Süresi 2' : null;
    kod=="tv314" ? metin='Çalışma Süresi 3' : null;
    kod=="tv315" ? metin='Çalışma Süresi 4' : null;
    kod=="tv316" ? metin='Durma Süresi 1' : null;
    kod=="tv317" ? metin='Durma Süresi 2' : null;
    kod=="tv318" ? metin='Durma Süresi 3' : null;
    kod=="tv319" ? metin='Durma Süresi 4' : null;
    kod=="tv320" ? metin='Fasıla Bölge 1' : null;
    kod=="tv321" ? metin='Fasıla Bölge 2' : null;
    kod=="tv322" ? metin='Fasıla Bölge 3' : null;
    kod=="tv323" ? metin='Fasıla Bölge 4' : null;
    kod=="tv324" ? metin='Fan' : null;
    kod=="tv325" ? metin='Min. Hav. Klasik' : null;
    kod=="tv326" ? metin='Fasıla Set 1' : null;
    kod=="tv327" ? metin='Fasıla Set 2' : null;
    kod=="tv328" ? metin='Fasıla Set 3' : null;
    kod=="tv329" ? metin='Aç Saati 1' : null;
    kod=="tv330" ? metin='Aç Saati 2' : null;
    kod=="tv331" ? metin='Kapa Saati 1' : null;
    kod=="tv332" ? metin='Kapa Saati 2' : null;
    kod=="tv333" ? metin='Aç-Kapa Saati 2\nAktif' : null;
    kod=="tv334" ? metin='Dimmer' : null;
    kod=="tv335" ? metin='Gündüz-Gece Ayd. Yüzdesi 1' : null;
    kod=="tv336" ? metin='Gündüz-Gece Ayd. Yüzdesi 2' : null;
    kod=="tv337" ? metin='Doğuş-Batış\nSüresi (Sn)' : null;
    kod=="tv338" ? metin='Saat' : null;
    kod=="tv339" ? metin='Dakika' : null;
    kod=="tv340" ? metin='Ayd. Yüzdesi(%)' : null;
    kod=="tv341" ? metin='Anlık Ayd. Yüzdesi(%)' : null;
    kod=="tv342" ? metin='Aydınlık Yüzdesi Çizelgesi' : null;
    kod=="tv343" ? metin='Gündüz Yüzdesi 1' : null;
    kod=="tv344" ? metin='Gündüz Yüzdesi 2' : null;
    kod=="tv345" ? metin='Gece Yüzdesi 1' : null;
    kod=="tv346" ? metin='Gece Yüzdesi 2' : null;
    kod=="tv347" ? metin='SÜRÜ' : null;
    kod=="tv348" ? metin='KALİBRASYON' : null;
    kod=="tv349" ? metin='Girişler' : null;
    kod=="tv350" ? metin='GİRİŞLER' : null;
    kod=="tv351" ? metin='Girişlerin Atanması' : null;
    kod=="tv352" ? metin='Acil Stop' : null;
    kod=="tv353" ? metin='Faz Koruma' : null;
    kod=="tv354" ? metin='Elk. Kesildi' : null;
    kod=="tv355" ? metin='Fan Termik' : null;
    kod=="tv356" ? metin='Klp Termik' : null;
    kod=="tv357" ? metin='Ped Termik' : null;
    kod=="tv358" ? metin='Klp1 Aç Swç' : null;
    kod=="tv359" ? metin='Klp2 Aç Swç' : null;
    kod=="tv360" ? metin='Klp3 Aç Swç' : null;
    kod=="tv361" ? metin='Klp4 Aç Swç' : null;
    kod=="tv362" ? metin='Klp5 Aç Swç' : null;
    kod=="tv363" ? metin='Klp6 Aç Swç' : null;
    kod=="tv364" ? metin='Klp7 Aç Swç' : null;
    kod=="tv365" ? metin='Klp8 Aç Swç' : null;
    kod=="tv366" ? metin='Klp9 Aç Swç' : null;
    kod=="tv367" ? metin='Klp10 Aç Swç' : null;
    kod=="tv368" ? metin='Klp1 Kapa Swç' : null;
    kod=="tv369" ? metin='Klp2 Kapa Swç' : null;
    kod=="tv370" ? metin='Klp3 Kapa Swç' : null;
    kod=="tv371" ? metin='Klp4 Kapa Swç' : null;
    kod=="tv372" ? metin='Klp5 Kapa Swç' : null;
    kod=="tv373" ? metin='Klp6 Kapa Swç' : null;
    kod=="tv374" ? metin='Klp7 Kapa Swç' : null;
    kod=="tv375" ? metin='Klp8 Kapa Swç' : null;
    kod=="tv376" ? metin='Klp9 Kapa Swç' : null;
    kod=="tv377" ? metin='Klp10 Kapa Swç' : null;
    kod=="tv378" ? metin='Air1 Aç Swç' : null;
    kod=="tv379" ? metin='Air2 Aç Swç' : null;
    kod=="tv380" ? metin='Air1 Kapa Swç' : null;
    kod=="tv381" ? metin='Air2 Kapa Swç' : null;
    kod=="tv382" ? metin='A.Inlet Term.' : null;
    kod=="tv383" ? metin='B.Fan Term.' : null;
    kod=="tv384" ? metin='Isıtıcı Term.' : null;
    kod=="tv385" ? metin='Sirk. Term.' : null;
    kod=="tv386" ? metin='Su Sayacı 1' : null;
    kod=="tv387" ? metin='Su Sayacı 2' : null;
    kod=="tv388" ? metin='Su Sayacı 3' : null;
    kod=="tv389" ? metin='Su Sayacı 4' : null;
    kod=="tv390" ? metin='Su Sayacı 5' : null;
    kod=="tv391" ? metin='Su Sayacı 6' : null;
    kod=="tv392" ? metin='Su Sayacı 7' : null;
    kod=="tv393" ? metin='Su Sayacı 8' : null;
    kod=="tv394" ? metin='Su Sayacı 9' : null;
    kod=="tv395" ? metin='Su Sayacı 10' : null;
    kod=="tv396" ? metin='Su Sayacı 11' : null;
    kod=="tv397" ? metin='Su Sayacı 12' : null;
    kod=="tv398" ? metin='Su Sayaç\nSayısı' : null;
    kod=="tv399" ? metin='Pals Başına\nLitre' : null;
    kod=="tv400" ? metin='KURULUM' : null;
    kod=="tv401" ? metin='SİSTEM AYARLARI' : null;
    kod=="tv402" ? metin='SAAT & TARİH' : null;
    kod=="tv403" ? metin='SAAT & TARİH AYARLARI' : null;
    kod=="tv404" ? metin='YIL' : null;
    kod=="tv405" ? metin='AY' : null;
    kod=="tv406" ? metin='GÜN' : null;
    kod=="tv407" ? metin='SAAT' : null;
    kod=="tv408" ? metin='DAKİKA' : null;
    kod=="tv409" ? metin='Saat Formatı\n00:00-23:59' : null;
    kod=="tv410" ? metin='Tarih Formatı 1\nGG-AA-YYYY' : null;
    kod=="tv411" ? metin='Tarih Formatı 1\nAA-GG-YYYY' : null;
    kod=="tv412" ? metin='SAATİ ONAYLA' : null;
    kod=="tv413" ? metin='TARİHİ ONAYLA' : null;

   

    

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
    kod=="btn9" ? metin='Bitir' : null;
    kod=="btn10" ? metin='GİR' : null;
    
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
    kod=="toast68" ? metin='Şu anda zaten ilgili klepe için kalibrasyon devam ediyor.' : null;
    kod=="toast69" ? metin='Klepe kalibrasyon sadece ilgili klepe otomatik modda ise aktiftir.' : null;
    kod=="toast70" ? metin='Kalibrasyon başladı...' : null;
    kod=="toast71" ? metin='Kalibrasyon sonlandırıldı...' : null;
    kod=="toast72" ? metin='Bu parametre "Fasıla Döngü Süresi" 10 dk olarak seçiliyse aktif edilebilir' : null;
    kod=="toast73" ? metin='Yapılan değişiklikleri sisteme göndemediniz!' : null;
    kod=="toast74" ? metin='Lütfen önce "Ac-Kapa Saati 2 Aktif" seçeneğini işaretleyin!' : null;
    kod=="toast75" ? metin='Dimmer aktifken devre dışıdır!' : null;
    kod=="toast76" ? metin='Lütfen tüm girişler için atama yapınız!' : null;
    


    //endregion



    //region Information metinleri


    

    

    //TF mod: Lineer ,  Bacafan: Var
    kod=="info1" ? metin='Kümes içi ortalama sıcaklık (G) ve (F) bölgesinde ise Minimum Hav. modu, (E) bölgesinde ise Çapraz Hav. modu, (D) bölgesinde ise'
    ' Tünel Hav. modu etkindir.\n\n'
    'Minimum Havalandırma:\n'
    ' (F) bölgesinde diğer adıyla "DOĞAL BÖLGE" de minimum havalandırma görevini yapan baca fanları kesintisiz çalışırlar.\n'
    ' (G) bölgesinde minimum havalandırma görevini yapan baca fanları bir süre durma, bir süre çalışma şeklinde fasılalı olarak çalışırlar.'
    ' Fasıla süreleri seçilen "Minimum Havalandırma Yöntemi" kapsamında sistem tarafından hesaplanır.\n\n'
    'Çapraz Havalandırma:\n'
    ' (E) bölgesinde Minimum havalandırmayı gerçekleştiren baca fanlarıyla, Tünel havalandırmayı gerçekleştiren tünel fanlarının birlikte'
    ' çalıştığı havalandırmadır. Bu bölgede Sistemin hesapladığı adet kadar tünel fanıyla birlikte baca fanları kesintisiz'
    ' olarak çalışırlar.\n\n'
    'Tünel Havalandırma:\n'
    ' Tünel havalandırma (A+B) sıcaklığında yani "DOĞAL BÖLGE" bitiş sıcaklığında başlar. (A+B) sıcaklığında minimum adet kadar fanı devreye sokar, (A+B+C+H)'
    ' sıcaklığına kadar çalışan fan sayısını lineer olarak artırır.Lineer artış kademesi "Fan Kademesi" parametresi ile belirlenir. Buna göre ortalama'
    ' sıcaklık arttıkça artış miktarında tanımlanan adet kadar fan devreye girer ve (A+B+C+H) sıcaklığında tüm fanlar devrede olur. Böylece tünel fanları (E) bölgesinde'
    ' baca fanlarıyla birlikte, (D) bölgesinde ise tek başına devrede olmuş olur.\n\n\n' : null;


    //TF mod: Lineer ,  Bacafan: Yok
    kod=="info2" ? metin='Kümes içi ortalama sıcaklık (G) ve (F) bölgesinde ise Minimum Hav. modu, (D) bölgesinde ise'
    ' Tünel Hav. modu etkindir.\n\n'
    'Minimum Havalandırma:\n'
    ' (F) bölgesinde diğer adıyla "DOĞAL BÖLGE" de minimum havalandırma görevini tünel fanlarından seçilen birkaç fan yapar ve bu bölgede bu fanlar kesintisiz çalışırlar.\n'
    ' (G) bölgesinde minimum havalandırma görevini yapan birkaç tünel fanı bir süre durma, bir süre çalışma şeklinde fasılalı olarak çalışırlar.'
    ' Fasıla süreleri seçilen "Minimum Havalandırma Yöntemi" kapsamında sistem tarafından hesaplanır. Tünel fanlarının birkaçının minimum havalandırma için'
    ' atanması "MİN. HAV." ayarlarından yapılır.\n\n'
    'Tünel Havalandırma:\n'
    ' Tünel havalandırma (A+B) sıcaklığında yani "DOĞAL BÖLGE" bitiş sıcaklığında başlar. (A+B) sıcaklığında minimum adet kadar fanı devreye sokar, (A+B+C+H)'
    ' sıcaklığına kadar çalışan fan sayısını lineer olarak artırır. Lineer artış kademesi "Fan Kademesi" parametresi ile belirlenir. Buna göre ortalama'
    ' sıcaklık arttıkça artış miktarında tanımlanan adet kadar fan devreye girer ve (A+B+C+H) sıcaklığında tüm fanlar devrede olur.\n\n\n' : null;






    //TF mod: Klasik ,  Bacafan: Yok
    kod=="info3" ? metin='Kümes içi ortalama sıcaklık (G) ve (F) bölgesinde ise Minimum Hav. modu, (D) bölgesinde ise'
    ' Tünel Hav. modu etkindir.\n\n'
    'Minimum Havalandırma:\n'
    ' (F) bölgesinde diğer adıyla "DOĞAL BÖLGE" de minimum havalandırma görevini tünel fanlarından seçilen birkaç fan yapar ve bu bölgede bu fanlar kesintisiz çalışırlar.\n'
    ' (G) bölgesinde minimum havalandırma görevini yapan birkaç tünel fanı bir süre durma, bir süre çalışma şeklinde fasılalı olarak çalışırlar.'
    ' Fasıla süreleri seçilen "Minimum Havalandırma Yöntemi" kapsamında sistem tarafından hesaplanır. Tünel fanlarının birkaçının minimum havalandırma için'
    ' atanması "MİN. HAV." ayarlarından yapılır.\n\n'
    'Tünel Havalandırma:\n'
    ' Kullanıcı her bir fan için (A+B) sıcaklığında ve üzerinde olacak şekilde set değerleri tanımlar. Ortalama sıcaklık her bir fan için ayrı ayrı belirlenen'
    ' set değerinin üzerine çıktığında ilgili fan çalışır, altına indiğinde ilgili fan durur.\n\n\n' : null;


    //TF mod: Klasik ,  Bacafan: Var
    kod=="info4" ? metin='Kümes içi ortalama sıcaklık (G) ve (F) bölgesinde ise Minimum Hav. modu, (E) bölgesinde ise Çapraz Hav. modu, (D) bölgesinde ise'
    ' Tünel Hav. modu etkindir.\n\n'
    'Minimum Havalandırma:\n'
    ' (F) bölgesinde diğer adıyla "DOĞAL BÖLGE" de minimum havalandırma görevini yapan baca fanları kesintisiz çalışırlar.\n'
    ' (G) bölgesinde minimum havalandırma görevini yapan baca fanları bir süre durma, bir süre çalışma şeklinde fasılalı olarak çalışırlar.'
    ' Fasıla süreleri seçilen "Minimum Havalandırma Yöntemi" kapsamında sistem tarafından hesaplanır.\n\n'
    'Çapraz Havalandırma:\n'
    ' (E) bölgesinde Minimum havalandırmayı gerçekleştiren baca fanlarıyla, Tünel havalandırmayı gerçekleştiren tünel fanlarının birlikte'
    ' çalıştığı havalandırmadır. Bu bölgede kullanıcının ayarladığı adet kadar tünel fanıyla birlikte baca fanları kesintisiz'
    ' olarak çalışırlar.\n\n'
    'Tünel Havalandırma:\n'
    ' Kullanıcı her bir fan için (A+B) sıcaklığında ve üzerinde olacak şekilde set değerleri tanımlar. Ortalama sıcaklık her bir fan için ayrı ayrı belirlenen'
    ' set değerinin üzerine çıktığında ilgili fan çalışır, altına indiğinde ilgili fan durur. Böylece tünel fanları (E) bölgesinde'
    ' baca fanlarıyla birlikte, (D) bölgesinde ise tek başına devrede olmuş olur.\n\n\n' : null;







    //TF mod: PID ,  Bacafan: Yok
    kod=="info5" ? metin='Kümes içi ortalama sıcaklık (G) bölgesinde ise Minimum Hav. modu, (D) bölgesinde ise'
    ' Tünel Hav. modu etkindir.\n\n'
    'Minimum Havalandırma:\n'
    ' (G) bölgesinde minimum havalandırma görevini yapan birkaç tünel fanı bir süre durma, bir süre çalışma şeklinde fasılalı olarak çalışırlar.'
    ' Fasıla süreleri seçilen "Minimum Havalandırma Yöntemi" kapsamında sistem tarafından hesaplanır. Tünel fanlarının birkaçının minimum havalandırma için'
    ' atanması "MİN. HAV." ayarlarından yapılır.\n\n'
    'Tünel Havalandırma:\n'
    ' PID kontrol yönteminde ortalama sıcaklık (A) noktası ve üstünde ise PLC ortam sıcaklığının ısınma ve soğuma'
    ' hızlarını algılar, bu hızları kontrol edebilecek yeterlilikte tünel fan sayısını hesaplar ve devreye sokar.': null;

    //TF mod: PID ,  Bacafan: Var
    kod=="info6" ? metin='Kümes içi ortalama sıcaklık (G) bölgesinde ise Minimum Hav. modu, (E) bölgesinde ise Çapraz Hav. modu, (D) bölgesinde ise'
    ' Tünel Hav. modu etkindir.\n\n'
    'Minimum Havalandırma:\n'
    ' (G) bölgesinde minimum havalandırma görevini yapan baca fanları bir süre durma, bir süre çalışma şeklinde fasılalı olarak çalışırlar.'
    ' Fasıla süreleri seçilen "Minimum Havalandırma Yöntemi" kapsamında sistem tarafından hesaplanır.\n\n'
    'Çapraz Havalandırma:\n'
    ' (E) bölgesinde Minimum havalandırmayı gerçekleştiren baca fanlarıyla, Tünel havalandırmayı gerçekleştiren tünel fanlarının birlikte'
    ' çalıştığı havalandırmadır. Bu bölgede PID\'nin hesapladığı adet kadar tünel fanıyla birlikte baca fanları kesintisiz'
    ' olarak çalışırlar.\n\n'
    'Tünel Havalandırma:\n'
    ' PID kontrol yönteminde ortalama sıcaklık (A) noktası ve üstünde ise PLC ortam sıcaklığının ısınma ve soğuma'
    ' hızlarını algılar, bu hızları kontrol edebilecek yeterlilikte tünel fan sayısını hesaplar ve devreye sokar. Böylece tünel fanları (E) bölgesinde'
    ' baca fanlarıyla birlikte, (D) bölgesinde ise tek başına devrede olmuş olur.\n\n\n' : null;







    //KLEPE mod: Klasik
    kod=="info7" ? metin='Çalışan fan sayısı A değerinden B değerine yükseldiğinde klepe açıklık oranı da E değerinden F değerine orantılı olarak yükselir.'
    '\n\nAynı şekilde çalışan fan sayısı C değerinden D değerin yükseldiğinde klepe açıklık oranı da G değerinden H değerine orantılı olarak yükselir.'
    '\n\nSenaryo 1 B,C değerlerinin birbirine eşit ve F,G değerlerinin birbirine eşit durumudur. Senaryo 2 de bu değerlerin birbirinden farklı durumudur.'
    'Eğer B ve C değerleri birbirinden farklı ise B-C arasında klepe açıklık oranı F olur ve sabit kalır.' : null;

    //KLEPE mod: Tunel
    kod=="info8" ? metin='Mevcut tüm klepelere 1\'den 5\'e kadar çalışma sırası belirlenebilir. Bunun anlamı 1. sırada klepe1 çalışsın, 2. sırada klepe2 ve klepe3 çalışsın, 3. sırada klepe4 ve klepe5'
    ' çalışsın şeklinde ayarlanabilir.\n\nEğer "Klp Baş. Düş Fan Modu" parametresi otomatikte ise, toplam fan sayısı klepelerin uzunlukları oranında klepelere pay edilir. Örn 15m-30m-30m şeklinde 3'
    ' klepeniz ve toplam 20 fanınız varsa fanlar klepelere 4-8-8 şeklinde pay edilecektir. Bu örnekte çalışma sırası 15m\'lik klepe için 1, 30m\'lik iki klepe de 2 olsun. 1. sıranın toplam fan sayısı 4,'
    ' 2. sıranın toplam fan sayısı 16 olur.\n\nBuna göre klepe1:\nÇalışan fan sayısı 0\'dan 4\'e(A) çıkarken klepe açıklığı da minimumdan(K1) maksimuma(L1) çıkar.\n\nAynı şekilde klepe2-3:\nÇalışan'
    ' fan sayısı 4\'ten(A) 20\'ye(B) çıkarken klepe açıklığı da minimumdan(K2) maksimuma(L2) çıkar.\n\n Eğer "Klp Baş. Düş Fan Modu" ilgili klepe için manuel de ise o klepeye düşen fan sayısı'
    ' manuel olarak elle girilmelidir' : null;

    //KLEPE Kalibrasyon
    kod=="info9" ? metin='* Klepe Kalibrasyon işlemi sadece ilgili klepe Otomatik modda ise gerçekleştirilebilir\n\n'
    '* İlgili klepe Manuel moddan Otomatik moda geçirildiğinde ilk olarak kalibrasyon işlemini yapar sonra normal işleyişine geçer\n\n'
    '* Bütün klepeler gece 23.50-00.00 arasında otomatik olarak kalibrasyon yaparak kalibrasyonunu günceller.\n\n'
    '* Kalibrasyon işlemi başlatıldığında klepe ilk önce bulunduğu konumdan tamamen açık konuma gelir. Daha sonra tam açık konumdan '
    ' tam kapalı konuma geçer ve bu işlem sırasında kalibrasyon süresi hesaplanır. Kalibrasyon tamamlandığında klepe çalışan fan sayısına göre'
    ' sistemin hesapladığı aralık kadar açılır.' : null;



    //Soğutma ayarları
    kod=="info10" ? metin=' Ortalama sıcaklık değeri ilgili ped pompasının \"Çalışma Sıcaklığı(A+B)\" değerine yükseldiğinde ped pompası çalışmaya başlar. Ortalama sıcaklık değeri'
    ' ilgili ped pompasının \"Durma Sıcaklığı(A+C)\" değerine düşünceye kadar ped pompası çalışmaya devam eder.\n\n Kümes içi nem değeri girilen \"Maksimum Nem(D)\" değerine ulaştığu zaman'
    ' sistem \"Yüksek Nem Aktif\" durumuna geçer ve hiçbir ped pompasının çalışmasına izin vermez. İç nem değeri \"Maksimum Nem\" değerinin \"Nem Fark(E)\" kadar altına düştüğünde'
    ' \"Yüksek Nem Pasif\" durumuna geçer ve ped pompalarının çalışmasına izin verir.\n\n Ped pompaları ortalama sıcaklığa göre çalışma durumuna geçtiğinde çalışmayı fasılalı'
    ' olarak yapar. \"Çalışma Sür.(Sn)\" kadar çalışır, \"Durma Sür.(Sn)\" kadar bekler.' : null;


    //Isıtma ayarları
    kod=="info11" ? metin=' Kümes içi ortalama sıcaklık değeri ilgili ısıtıcı grubu için girilen \"Çalışma Sıcaklığı(A-B)\" değerine düştüğünde ısıtıcı grubu start alır. '
    'Ortalama sıcaklık ilgili ısıtıcı grubunun \"Durma Sıcaklığı(A-C)\" değerine yükseldiğinde ısıtıcı grubu stop duruma geçer.' : null;


    //MH Ağırlık(Civciv-Broiler) (Air inletli)
    kod=="info12" ? metin='   Minimum Havalandırma Ağırlık Modu\'nda sistem hayvanların ağırlıklarına göre saatlik temiz hava ihtiyaçları üzerinden gerekli hesaplamaları yapar ve'
    ' minimum havalandırma için belirlenen fanlar buna göre kontrol edilir. 7 Haftalık büyüme döneminde hayvanın her hafta için ağırlığına göre ihtiyaç duyduğu m3/h bazında '
    ' hava ihtiyacı bilgisi katalogtan elde edilerek "7 Haftalık Hayvan Başına İhtiyaç(m3/h)" alanına girilir.\n\n'
    '     Sistem sürü yaşına göre hayvan başına düşen hava ihtiyacını tespit eder ve bu bilgi üzerinden tüm sürü için 5dk\'daki veya 10dk\'daki toplam hava ihtiyacını hesaplar.'
    ' Hesaplanan bu hava ihtiyacını karşılamak için 5dk\'nın veya 10dk\'nın bir kısmında durma, bir kısmında çalışma şeklinde fasıla yaparak Min. Hav. fanlarını çalıştırır '
    ' Baca fanı varsa baca fanlarının toplam debisini hesaba katarak fasıla sürelerini hesaplar. Eğer baca fanı yok da tünel fanlarından birkaçı Min. Hav. için'
    ' kullanılacaksa kaç tane tünel fanının çalışacağını ve ne kadar fasıla yapacağını hesaplanan hava ihtiyacına göre sistem belirler\n\n'
    '     Fasılada Maks. Çalışma Yüzdesi:\n'
    ' Min. Hav. fanları fasıla yaparken toplam döngü süresinin en fazla % kaçı kadarında çalışır pozisyonda kalabileceğinin belirlendiği parametredir. Örneğin 1 fan ile hava '
    ' ihtiyacını karşılamak için sistem bu parametreye girilen değerden daha yüksek bir süre hesaplarsa fan sayısını bir artırarak çalışma süresini bu parametredeki değerin'
    ' altına düşürmeye çalışır.\n\n'
    '     Air Inlet Öncelik Süresi:\n'
    ' Fasıla sırasında Min. Hav. fanları devreye girmeden kaç sn önce Air Inlet\'lerin açılmaya başlamasını belirleyen parametredir\n\n'
    '     Hava Giriş Yüzdesi:\n'
    ' Hesaplanan toplam hava ihtiyacının % kaçının Min. Hav. fanlarıyla karşılanacağını belirleyen parametredir.\n\n'
    '     Fasıla Durma\'da Air Inlet Kapansın mı?:\n'
    ' Bu parametre aktifleştirildiğinde sistem fasılanın durma pozisyonunda air inletleri kapatır. Eğer air inletlerin tam açık pozisyondan tam kapa pozisyona gelme'
    ' süresi Fasıla Durma süresinden büyük olduğunda bu özellik devre dışıdır.\n\n'
    '     Fasıla Döngü Süresi:\n'
    ' Minimum havalandırma fasıla modundayken fasılayı bu parametreye göre yapar. Seçili sürenin hesaplanan bir kısmında Min. Hav fanları çalışır, kalan kısmında'
    ' Min. Hav fanları durur.'  : null;

    //MH Ağırlık(Civciv-Broiler) (Air inletsiz)
    kod=="info13" ? metin='   Minimum Havalandırma Ağırlık Modu\'nda sistem hayvanların ağırlıklarına göre saatlik temiz hava ihtiyaçları üzerinden gerekli hesaplamaları yapar ve'
    ' minimum havalandırma için belirlenen fanlar buna göre kontrol edilir. 7 Haftalık büyüme döneminde hayvanın her hafta için ağırlığına göre ihtiyaç duyduğu m3/h bazında'
    ' hava ihtiyacı bilgisi katalogtan elde edilerek "7 Haftalık Hayvan Başına İhtiyaç(m3/h)" alanına girilir.\n\n'
    '   Sistem sürü yaşına göre hayvan başına düşen hava ihtiyacını tespit eder ve bu bilgi üzerinden tüm sürü için 5dk\'daki veya 10dk\'daki toplam hava ihtiyacını hesaplar.'
    ' Hesaplanan bu hava ihtiyacını karşılamak için 5dk\'nın veya 10dk\'nın bir kısmında durma, bir kısmında çalışma şeklinde fasıla yaparak Min. Hav. fanlarını çalıştırır'
    ' Baca fanı varsa baca fanlarının toplam debisini hesaba katarak fasıla sürelerini hesaplar. Eğer baca fanı yoksa tünel fanlarından birkaçı Min. Hav. için'
    ' kullanılacaksa kaç tane tünel fanının çalışacağını ve ne kadar fasıla yapacağını hesaplanan hava ihtiyacına göre sistem belirler\n\n'
    '     Fasılada Maks. Çalışma Yüzdesi:\n'
    ' Min. Hav. fanları fasıla yaparken toplam döngü süresinin en fazla % kaçı kadarında çalışır pozisyonda kalabileceğinin belirlendiği parametredir. Örneğin 1 fan ile hava'
    ' ihtiyacını karşılamak için sistem bu parametreye girilen değerden daha yüksek bir süre hesaplarsa fan sayısını bir artırarak çalışma süresini bu parametredeki değerin'
    ' altına düşürmeye çalışır.\n\n'
    '     Hava Giriş Yüzdesi:\n'
    ' Hesaplanan toplam hava ihtiyacının % kaçının Min. Hav. fanlarıyla karşılanacağını belirleyen parametredir.\n\n'
    '     Fasıla Döngü Süresi:\n'
    ' Minimum havalandırma fasıla modundayken fasılayı bu parametreye göre yapar. Seçili sürenin hesaplanan bir kısmında Min. Hav fanları çalışır, kalan kısmında'
    ' Min. Hav fanları durur.'  : null;


     //MH Ağırlık(Tavuk) (Air inletli)
    kod=="info14" ? metin='     Minimum Havalandırma Ağırlık Modu\'nda sistem hayvanların ağırlıklarına göre saatlik temiz hava ihtiyaçları üzerinden gerekli hesaplamaları yapar ve'
    ' minimum havalandırma için belirlenen fanlar buna göre kontrol edilir. Sürünün "Dönemlik Hayvan Başına Hava İhtiyacı(m3/h)" alanında belirtilen her dönem için ağırlığına '
    ' göre ihtiyaç duyduğu m3/h bazında hava ihtiyacı bilgisi katalogtan elde edilerek "Dönemlik Hayvan Başına Hava İhtiyacı(m3/h)" alanına girilir.\n\n'
    ' Sistem sürü yaşına göre hayvan başına düşen hava ihtiyacını tespit eder ve bu bilgi üzerinden tüm sürü için 5dk\'daki veya 10dk\'daki toplam hava ihtiyacını hesaplar.'
    ' Hesaplanan bu hava ihtiyacını karşılamak için 5dk\'nın veya 10dk\'nın bir kısmında durma, bir kısmında çalışma şeklinde fasıla yaparak Min. Hav. fanlarını çalıştırır '
    ' Baca fanı varsa baca fanlarının toplam debisini hesaba katarak fasıla sürelerini hesaplar. Eğer baca fanı yoksa tünel fanlarından birkaçı Min. Hav. için'
    ' kullanılacaksa kaç tane tünel fanının çalışacağını ve ne kadar fasıla yapacağını hesaplanan hava ihtiyacına göre sistem belirler\n\n'
    '     Fasılada Maks. Çalışma Yüzdesi:\n'
    ' Min. Hav. fanları fasıla yaparken toplam döngü süresinin en fazla % kaçı kadarında çalışır pozisyonda kalabileceğinin belirlendiği parametredir. Örneğin 1 fan ile hava '
    ' ihtiyacını karşılamak için sistem bu parametreye girilen değerden daha yüksek bir süre hesaplarsa fan sayısını bir artırarak çalışma süresini bu parametredeki değerin '
    ' altına düşürmeye çalışır.\n\n'
    '     Air Inlet Öncelik Süresi:\n'
    ' Fasıla sırasında Min. Hav. fanları devreye girmeden kaç sn önce Air Inlet\'lerin açılmaya başlamasını belirleyen parametredir\n\n'
    '     Hava Giriş Yüzdesi:\n'
    ' Hesaplanan toplam hava ihtiyacının % kaçının Min. Hav. fanlarıyla karşılanacağını belirleyen parametredir.\n\n'
    '     Fasıla Durma\'da Air Inlet Kapansın mı?:\n'
    ' Bu parametre aktifleştirildiğinde sistem fasılanın durma pozisyonunda air inletleri kapatır. Eğer air inletlerin tam açık pozisyondan tam kapa pozisyona gelme'
    ' süresi Fasıla Durma süresinden büyük olduğunda bu özellik devre dışıdır.\n\n'
    '     Fasıla Döngü Süresi:\n'
    ' Minimum havalandırma fasıla modundayken fasılayı bu parametreye göre yapar. Seçili sürenin hesaplanan bir kısmında Min. Hav fanları çalışır, kalan kısmında'
    ' Min. Hav fanları durur.'  : null;

    //MH Ağırlık(Tavuk) (Air inletsiz)
    kod=="info15" ? metin='   Minimum Havalandırma Ağırlık Modu\'nda sistem hayvanların ağırlıklarına göre saatlik temiz hava ihtiyaçları üzerinden gerekli hesaplamaları yapar ve'
    ' minimum havalandırma için belirlenen fanlar buna göre kontrol edilir. Sürünün "Dönemlik Hayvan Başına Hava İhtiyacı(m3/h)" alanında belirtilen her dönem için ağırlığına '
    ' göre ihtiyaç duyduğu m3/h bazında hava ihtiyacı bilgisi katalogtan elde edilerek "Dönemlik Hayvan Başına Hava İhtiyacı(m3/h)" alanına girilir.\n\n'
    ' Sistem sürü yaşına göre hayvan başına düşen hava ihtiyacını tespit eder ve bu bilgi üzerinden tüm sürü için 5dk\'daki veya 10dk\'daki toplam hava ihtiyacını hesaplar.'
    ' Hesaplanan bu hava ihtiyacını karşılamak için 5dk\'nın veya 10dk\'nın bir kısmında durma, bir kısmında çalışma şeklinde fasıla yaparak Min. Hav. fanlarını çalıştırır '
    ' Baca fanı varsa baca fanlarının toplam debisini hesaba katarak fasıla sürelerini hesaplar. Eğer baca fanı yoksa tünel fanlarından birkaçı Min. Hav. için'
    ' kullanılacaksa kaç tane tünel fanının çalışacağını ve ne kadar fasıla yapacağını hesaplanan hava ihtiyacına göre sistem belirler\n\n'
    '     Fasılada Maks. Çalışma Yüzdesi:\n'
    ' Min. Hav. fanları fasıla yaparken toplam döngü süresinin en fazla % kaçı kadarında çalışır pozisyonda kalabileceğinin belirlendiği parametredir. Örneğin 1 fan ile hava '
    ' ihtiyacını karşılamak için sistem bu parametreye girilen değerden daha yüksek bir süre hesaplarsa fan sayısını bir artırarak çalışma süresini bu parametredeki değerin '
    ' altına düşürmeye çalışır.\n\n'
    '     Hava Giriş Yüzdesi:\n'
    ' Hesaplanan toplam hava ihtiyacının % kaçının Min. Hav. fanlarıyla karşılanacağını belirleyen parametredir.\n\n'
    '     Fasıla Döngü Süresi:\n'
    ' Minimum havalandırma fasıla modundayken fasılayı bu parametreye göre yapar. Seçili sürenin hesaplanan bir kısmında Min. Hav fanları çalışır, kalan kısmında'
    ' Min. Hav fanları durur.'  : null;



    //MH Hacim (Air inletli)
    kod=="info16" ? metin='   Minimum Havalandırma Hacim Modu\'nda sistem kurulum ayarlarından girilen bina ölçüleri ve hacim oranı değerine göre hesaplanan kümes içindeki'
    ' aktif hacim miktarı kadar havanın seçilen döngü süresinde kümes dışına atılması, dışarı atılan kirli hava kadar taze havanın da kümes içine alınmasını sağlar.\n\n'
    '     Hesaplanan aktif hacmin değişimi için 5dk\'nın veya 10dk\'nın bir kısmında durma, bir kısmında çalışma şeklinde fasıla yaparak Min. Hav. fanlarını çalıştırır '
    ' Baca fanı varsa baca fanlarının toplam debisini hesaba katarak fasıla sürelerini hesaplar. Eğer baca fanı yok da tünel fanlarından birkaçı Min. Hav. için'
    ' kullanılacaksa kaç tane tünel fanının çalışacağını ve ne kadar fasıla yapacağını hesaplanan aktif hacim miktarına göre sistem belirler\n\n'
    '     Fasılada Maks. Çalışma Yüzdesi:\n'
    ' Min. Hav. fanları fasıla yaparken toplam döngü süresinin en fazla % kaçı kadarında çalışır pozisyonda kalabileceğinin belirlendiği parametredir. Örneğin 1 fan ile hava '
    ' ihtiyacını karşılamak için sistem bu parametreye girilen değerden daha yüksek bir süre hesaplarsa fan sayısını bir artırarak çalışma süresini bu parametredeki değerin'
    ' altına düşürmeye çalışır.\n\n'
    '     Air Inlet Öncelik Süresi:\n'
    ' Fasıla sırasında Min. Hav. fanları devreye girmeden kaç sn önce Air Inlet\'lerin açılmaya başlamasını belirleyen parametredir\n\n'
    '     Hava Giriş Yüzdesi:\n'
    ' Hesaplanan toplam aktif hacim değişiminin % kaçının Min. Hav. fanlarıyla karşılanacağını belirleyen parametredir.\n\n'
    '     Fasıla Durma\'da Air Inlet Kapansın mı?:\n'
    ' Bu parametre aktifleştirildiğinde sistem fasılanın durma pozisyonunda air inletleri kapatır. Eğer air inletlerin tam açık pozisyondan tam kapa pozisyona gelme'
    ' süresi Fasıla Durma süresinden büyük olduğunda bu özellik devre dışıdır.\n\n'
    '     Fasıla Döngü Süresi:\n'
    ' Minimum havalandırma fasıla modundayken fasılayı bu parametreye göre yapar. Seçili sürenin hesaplanan bir kısmında Min. Hav fanları çalışır, kalan kısmında'
    ' Min. Hav fanları durur.'  : null;



    //MH Klasik
    kod=="info17" ? metin='   Doğal Bölge\'de ve set değerinin altında 4 adete kadar fanın hangi fasıla süreleriyle çalışacağının kullanıcı tarafından belirlendiği'
    ' sistemdir. 4 adet fandan hangisi veya hangileri seçilmişse sistem min. hav. modundaysa sadece seçili bu fanlar çalışır.\n\n'
    ' (K) Bölgesi:\n'
    ' Seçilen fanlar kesintisiz çalışır.\n\n'
    ' (F) Bölgesi:\n'
    ' Ortalama sıcaklık, Set Sıcaklığı(A) değerinden küçük Fasıla Set 1(C) değerinden büyük olduğunda fanlar "Çalışma Süresi 1" kadar çalışır "Durma Süresi 1" kadar durur.\n\n'
    ' (G) Bölgesi:\n'
    ' Ortalama sıcaklık, Fasıla Set 1(C) değerinden küçük veya eşit Fasıla Set 2(D) değerinden büyük olduğunda fanlar "Çalışma Süresi 2" kadar çalışır '
    ' "Durma Süresi 2" kadar durur.\n\n'
    ' (H) Bölgesi:\n'
    ' Ortalama sıcaklık, Fasıla Set 2(D) değerinden küçük veya eşit Fasıla Set 3(E) değerinden büyük olduğunda fanlar "Çalışma Süresi 3" kadar çalışır '
    ' "Durma Süresi 3" kadar durur.\n\n'
    ' (J) Bölgesi:\n'
    ' Ortalama sıcaklık, Fasıla Set 3(E) değerinden küçük veya eşit olduğunda fanlar "Çalışma Süresi 4" kadar çalışır "Durma Süresi 4" kadar durur.'  : null;



    //Aydınlatma dimmerli
    kod=="info18" ? metin=' Aydınlık şiddeti girilen yüzde değerlerine göre belirtilen saatlerde sistem tarafından ayarlanır.\n\n'
    ' "Aç Saati 1" geldiğinde sistem aydınlık şiddetini "Gündüz 1" değerine göre ayarlar\n\n'
    ' "Kapa Saati 1" geldiğinde sistem aydınlık şiddetini "Gece 1" değerine göre ayarlar\n\n'
    ' Eğer "Aç-Kapa Saati 2 Aktif" seçeneği aktif edilirse sistemi 2 kez dim yapmaya olanak sağlar aynı çalışma sistemi geçerlidir.\n\n'
    ' "Aç Saati 2" geldiğinde sistem aydınlık şiddetini "Gündüz 2" değerine göre ayarlar\n\n'
    ' "Kapa Saati 2" geldiğinde sistem aydınlık şiddetini "Gece 2" değerine göre ayarlar\n\n'
    ' Belirlenen saat geldiğinde gündüzden geceye veya geceden gündüze geçiş "Doğuş-Batış Süresi (Sn)" parametresine girilen sürede gerçekleşir.'  : null;


    //Aydınlatma dimmersiz
    kod=="info19" ? metin=' Kümesin aydınlatma sistemi saat "Aç Saati 1" e geldiğinde çalışır, "Kapa Saati 1" e geldiğinde de kapanır. \n\nEğer'
    ' "Aç-Kapa Saati 2 Aktif" seçeneği aktif edilirse sistemi 2 kez aç-kapa yapmaya olanak sağlar ve aynı çalışma sistemi geçerlidir.\n\n'
    ' Kümesin aydınlatma sistemi saat "Aç Saati 2" e geldiğinde çalışır, "Kapa Saati 2" e geldiğinde de kapanır.'  : null;


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
    kod=="tv13" ? metin='Flap Number' : null;
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
    kod=="tv27" ? metin='Flap Control Method' : null;
    kod=="tv28" ? metin='Tunnel Control' : null;
    kod=="tv29" ? metin='Build, Out Humidity and Flow' : null;
    kod=="tv30" ? metin='Out Hum' : null;
    kod=="tv31" ? metin='Fan Map' : null;
    kod=="tv32" ? metin='Fan:' : null;
    kod=="tv33" ? metin='Out:' : null;
    kod=="tv34" ? metin='FAN NO' : null;
    kod=="tv35" ? metin='OUT NO' : null;
    kod=="tv36" ? metin='Password match :' : null;
    kod=="tv37" ? metin='The map will reset! Are you sure?' : null;
    kod=="tv38" ? metin='Flap Map' : null;
    kod=="tv39" ? metin='Flp:' : null;
    kod=="tv40" ? metin='FLAP NO' : null;
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
    kod=="tv86" ? metin='ALARM OUT' : null;
    kod=="tv87" ? metin='WARNING OUT' : null;
    kod=="tv88" ? metin='LIGHT OUT' : null;
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
    kod=="tv105" ? metin='SYSTEM' : null;
    kod=="tv106" ? metin='CONTROL SETTINGS' : null;
    kod=="tv107" ? metin='TEMP. & HUM.' : null;
    kod=="tv108" ? metin='FLAP' : null;
    kod=="tv109" ? metin='COOL. & HUM.' : null;
    kod=="tv110" ? metin='MIN. VENT.' : null;
    kod=="tv111" ? metin='OTHER OPT.' : null;
    kod=="tv112" ? metin='LIGHTING' : null;
    kod=="tv113" ? metin='FEED & WATER' : null;
    kod=="tv114" ? metin='HELPER OPT.' : null;
    kod=="tv115" ? metin='Set temperature' : null;
    kod=="tv116" ? metin='Natural Zone finish temp.' : null;
    kod=="tv117" ? metin='Cross vent. finish temp.' : null;
    kod=="tv118" ? metin='Tunnel vent. active area' : null;
    kod=="tv119" ? metin='Cross vent. active area' : null;
    kod=="tv120" ? metin='Nat.Zone-Min.Vent Cont.' : null;
    kod=="tv121" ? metin='Min.Vent. Intermittent' : null;
    kod=="tv122" ? metin='Maks. fan temperature' : null;
    kod=="tv123" ? metin='Temperature Diagram' : null;
    kod=="tv124" ? metin='Navigator Menu' : null;
    kod=="tv125" ? metin='Set Temperature (A)' : null;
    kod=="tv126" ? metin='Naturel Zone Difference (B)' : null;
    kod=="tv127" ? metin='FANS OF SET TEMPERATURE (°C)' : null;
    kod=="tv128" ? metin='Cross Vent. Difference (C)' : null;
    kod=="tv129" ? metin='Bosta' : null;
    kod=="tv130" ? metin='Max. Fan Difference (H)' : null;
    kod=="tv131" ? metin='Day 1: ' : null;
    kod=="tv132" ? metin='Day 2: ' : null;
    kod=="tv133" ? metin='Day 3: ' : null;
    kod=="tv134" ? metin='Day 4: ' : null;
    kod=="tv135" ? metin='Day 5: ' : null;
    kod=="tv136" ? metin='Day 6: ' : null;
    kod=="tv137" ? metin='Day 7: ' : null;
    kod=="tv138" ? metin='Day 8: ' : null;
    kod=="tv139" ? metin='Day 9: ' : null;
    kod=="tv140" ? metin='Day 10: ' : null;
    kod=="tv141" ? metin='Day 11: ' : null;
    kod=="tv142" ? metin='Day 12: ' : null;
    kod=="tv143" ? metin='Day 13: ' : null;
    kod=="tv144" ? metin='Day 14: ' : null;
    kod=="tv145" ? metin='Day 15: ' : null;
    kod=="tv146" ? metin='Day 16: ' : null;
    kod=="tv147" ? metin='Day 17: ' : null;
    kod=="tv148" ? metin='Day 18: ' : null;
    kod=="tv149" ? metin='Day 19: ' : null;
    kod=="tv150" ? metin='Day 20: ' : null;
    kod=="tv151" ? metin='Day 21: ' : null;
    kod=="tv152" ? metin='Day 22: ' : null;
    kod=="tv153" ? metin='Day 23: ' : null;
    kod=="tv154" ? metin='Day 24: ' : null;
    kod=="tv155" ? metin='Day 25: ' : null;
    kod=="tv156" ? metin='Day 26: ' : null;
    kod=="tv157" ? metin='Day 27: ' : null;
    kod=="tv158" ? metin='Day 28: ' : null;
    kod=="tv159" ? metin='Day 29: ' : null;
    kod=="tv160" ? metin='Day 30: ' : null;
    kod=="tv161" ? metin='Day 31: ' : null;
    kod=="tv162" ? metin='Day 32: ' : null;
    kod=="tv163" ? metin='Day 33: ' : null;
    kod=="tv164" ? metin='Day 34: ' : null;
    kod=="tv165" ? metin='Day 35: ' : null;
    kod=="tv166" ? metin='Day 36: ' : null;
    kod=="tv167" ? metin='Day 37: ' : null;
    kod=="tv168" ? metin='Day 38: ' : null;
    kod=="tv169" ? metin='Day 39: ' : null;
    kod=="tv170" ? metin='Day 40: ' : null;
    kod=="tv171" ? metin='Day 41: ' : null;
    kod=="tv172" ? metin='Day 42: ' : null;
    kod=="tv173" ? metin='1. Day' : null;
    kod=="tv174" ? metin='7. Day' : null;
    kod=="tv175" ? metin='14. Day' : null;
    kod=="tv176" ? metin='21. Day' : null;
    kod=="tv177" ? metin='28. Day' : null;
    kod=="tv178" ? metin='35. Day' : null;
    kod=="tv179" ? metin='42. Day' : null;
    kod=="tv180" ? metin='DEFINITION OF WEEKLY SET TEMPERATURES' : null;
    kod=="tv181" ? metin='TEMPERATURE SET and FAN' : null;
    kod=="tv182" ? metin='Fan Step' : null;
    kod=="tv183" ? metin='Temp. Line(°C)' : null;
    kod=="tv184" ? metin='Temperature Chart' : null;
    kod=="tv185" ? metin='Set Temp. of Fans' : null;
    kod=="tv186" ? metin='Info' : null;
    kod=="tv187" ? metin='Nat. Zone' : null;
    kod=="tv188" ? metin='Set Temp' : null;
    kod=="tv189" ? metin='Cross Vent.' : null;
    kod=="tv190" ? metin='Tun. Vent.' : null;
    kod=="tv191" ? metin='PID Set Shift' : null;
    kod=="tv192" ? metin='FLAP' : null;
    kod=="tv193" ? metin='Fan - Flap Diagram' : null;
    kod=="tv194" ? metin='Aktuel Interval :' : null;
    kod=="tv195" ? metin='Working Fan 1-2 :' : null;
    kod=="tv196" ? metin='Flap Interval 1-2 :' : null;
    kod=="tv197" ? metin='Working Fan 3-4 :' : null;
    kod=="tv198" ? metin='Flap Interval 3-4 :' : null;
    kod=="tv199" ? metin='Min.Vent. Interval :' : null;
    kod=="tv200" ? metin='Working Fan 1' : null;
    kod=="tv201" ? metin='Working Fan 2' : null;
    kod=="tv202" ? metin='Working Fan 3' : null;
    kod=="tv203" ? metin='Working Fan 4' : null;
    kod=="tv204" ? metin='Flap Interval 1' : null;
    kod=="tv205" ? metin='Flap Interval 2' : null;
    kod=="tv206" ? metin='Flap Interval 3' : null;
    kod=="tv207" ? metin='Flap Interval 4' : null;
    kod=="tv208" ? metin='Scenario 1' : null;
    kod=="tv209" ? metin='Scenario 2' : null;
    kod=="tv210" ? metin='Number of Working Fan' : null;
    kod=="tv211" ? metin='Flap Interval persent' : null;
    kod=="tv212" ? metin='INTERVAL PARAMETERS - ' : null;
    kod=="tv213" ? metin='Fan Number per Flp :' : null;
    kod=="tv214" ? metin='Fan Number Per Flp Mod :' : null;
    kod=="tv215" ? metin='Work Queue :' : null;
    kod=="tv216" ? metin='Min-Max. Interval :' : null;
    kod=="tv217" ? metin='Fan Number per\nFlp for Man:' : null;
    kod=="tv218" ? metin='Max. Interval :' : null;
    kod=="tv219" ? metin='Min. Interval :' : null;
    kod=="tv220" ? metin='Auto :' : null;
    kod=="tv221" ? metin='Man :' : null;
    kod=="tv222" ? metin='Enter Manuel\nFan Number per Flp' : null;
    kod=="tv223" ? metin='End of W. Queue 1' : null;
    kod=="tv224" ? metin='Start of W. Queue 2' : null;
    kod=="tv225" ? metin='W.Queue1 Min. Interval' : null;
    kod=="tv226" ? metin='W.Queue1 Max. Interval' : null;
    kod=="tv227" ? metin='W.Queue2 Min. Interval' : null;
    kod=="tv228" ? metin='W.Queue2 Max. Interval' : null;
    kod=="tv229" ? metin='Work Queue 1' : null;
    kod=="tv230" ? metin='Work Queue 2' : null;
    kod=="tv231" ? metin='End of W. Queue 2' : null;
    kod=="tv232" ? metin='Calibration\nStart' : null;
    kod=="tv233" ? metin='Calibration State :' : null;
    kod=="tv234" ? metin='Calibration Time :' : null;
    kod=="tv235" ? metin='Flp Auto-Man State :' : null;
    kod=="tv236" ? metin='Active' : null;
    kod=="tv237" ? metin='Passive' : null;
    kod=="tv238" ? metin='Sec' : null;
    kod=="tv239" ? metin='FLAP CALIBRATION' : null;
    kod=="tv240" ? metin='Calibration Details' : null;
    kod=="tv241" ? metin='Flap\nCalibration' : null;
    kod=="tv242" ? metin='Start Temperature :' : null;
    kod=="tv243" ? metin='Stop Temperature :' : null;
    kod=="tv244" ? metin='PED P.' : null;
    kod=="tv245" ? metin='START TEMPERATURE DIFF.' : null;
    kod=="tv246" ? metin='STOP TEMPERATURE DIFF.' : null;
    kod=="tv247" ? metin='Start Temp. Diff.' : null;
    kod=="tv248" ? metin='Stop Temp. Diff.' : null;
    kod=="tv249" ? metin='COOLING PED PUMPS' : null;
    kod=="tv250" ? metin='Max. Hum.' : null;
    kod=="tv251" ? metin='Hum. Diff.' : null;
    kod=="tv252" ? metin='Maximum Hum.' : null;
    kod=="tv253" ? metin='Cooling Diagram' : null;
    kod=="tv254" ? metin='Start Temperature' : null;
    kod=="tv255" ? metin='Stop Temperature' : null;
    kod=="tv256" ? metin='Ped P. Passive Area' : null;
    kod=="tv257" ? metin='Ped P. SubActive Area' : null;
    kod=="tv258" ? metin='Ped P. Active Area' : null;
    kod=="tv259" ? metin='Max. Hum.Passive Area' : null;
    kod=="tv260" ? metin='Max. Hum. SubActive Area' : null;
    kod=="tv261" ? metin='Max. Hum. Active Area' : null;
    kod=="tv262" ? metin='HEATER Gr.' : null;
    kod=="tv263" ? metin='HEATER' : null;
    kod=="tv264" ? metin='Heater Diagram' : null;
    kod=="tv265" ? metin='Heater Avtive Area' : null;
    kod=="tv266" ? metin='Heater SubActive Area' : null;
    kod=="tv267" ? metin='Heater Passive Area' : null;
    kod=="tv268" ? metin='Start Temperature(A-B) :' : null;
    kod=="tv269" ? metin='Stop Temperature(A-C) :' : null;
    kod=="tv270" ? metin='On Time(Sn)' : null;
    kod=="tv271" ? metin='Off Time(Sn)' : null;
    kod=="tv272" ? metin='Maks. Start Time\nin Intermittent' : null;
    kod=="tv273" ? metin='Air Inlet\nPriority Time(Sec)' : null;
    kod=="tv274" ? metin='Air Inlet\nPercent(%)' : null;
    kod=="tv275" ? metin='Close Air Inlet in Intermittent stop state?' : null;
    kod=="tv276" ? metin='MINIMUM VENTILATION' : null;
    kod=="tv277" ? metin='Min. Vent.\nFan Number' : null;
    kod=="tv278" ? metin='Air Need\nPer Animal(m3/h)' : null;
    kod=="tv279" ? metin='Air Need Per Animal for 7 Weeks(m3/h)' : null;
    kod=="tv280" ? metin='Day 1-7' : null;
    kod=="tv281" ? metin='Day 8-14' : null;
    kod=="tv282" ? metin='Day 15-21' : null;
    kod=="tv283" ? metin='Day 22-28' : null;
    kod=="tv284" ? metin='Day 29-35' : null;
    kod=="tv285" ? metin='Day 36-42' : null;
    kod=="tv286" ? metin='Day 43-49' : null;
    kod=="tv287" ? metin='Day 50 and beyond' : null;
    kod=="tv288" ? metin='Back to Default Values' : null;
    kod=="tv289" ? metin='Air Need Per Animal as periodic(m3/h)' : null;
    kod=="tv290" ? metin='Week 7-20' : null;
    kod=="tv291" ? metin='Week 21-52' : null;
    kod=="tv292" ? metin='Week 53 and beyond' : null;
    kod=="tv293" ? metin='Min. Vent. Weight Mod' : null;
    kod=="tv294" ? metin='Intermittent Cycle Time(min)' : null;
    kod=="tv295" ? metin='Total Active\Volume(m3)' : null;
    kod=="tv296" ? metin='Total Active Volume Refresh Time?' : null;
    kod=="tv297" ? metin='5 min' : null;
    kod=="tv298" ? metin='10 min' : null;
    kod=="tv299" ? metin='INSTALLATION SETTINGS' : null;
    kod=="tv300" ? metin='Admin Password' : null;
    kod=="tv301" ? metin='Enter Password...' : null;
    kod=="tv302" ? metin='Quantities' : null;
    kod=="tv303" ? metin='Fan Con. Method' : null;
    kod=="tv304" ? metin='MV Con. Method' : null;
    kod=="tv305" ? metin='Flp Con. Method' : null;
    kod=="tv306" ? metin='Built,Hum,Flow' : null;
    kod=="tv307" ? metin='Ped Pum. Map' : null;
    kod=="tv308" ? metin='Temp. Sen. Map' : null;
    kod=="tv309" ? metin='Intermittent Set 1 (°C)' : null;
    kod=="tv310" ? metin='Intermittent Set 2 (°C)' : null;
    kod=="tv311" ? metin='Intermittent Set 3 (°C)' : null;
    kod=="tv312" ? metin='Start Time 1(Sec)' : null;
    kod=="tv313" ? metin='Start Time 2(Sec)' : null;
    kod=="tv314" ? metin='Start Time 3(Sec)' : null;
    kod=="tv315" ? metin='Start Time 4(Sec)' : null;
    kod=="tv316" ? metin='Stop Time 1(Sec)' : null;
    kod=="tv317" ? metin='Stop Time 2(Sec)' : null;
    kod=="tv318" ? metin='Stop Time 3(Sec)' : null;
    kod=="tv319" ? metin='Stop Time 4(Sec)' : null;
    kod=="tv320" ? metin='Inter. Area 1' : null;
    kod=="tv321" ? metin='Inter. Area 2' : null;
    kod=="tv322" ? metin='Inter. Area 3' : null;
    kod=="tv323" ? metin='Inter. Area 4' : null;
    kod=="tv324" ? metin='Fan' : null;
    kod=="tv325" ? metin='Min. Vent. Classic' : null;
    kod=="tv326" ? metin='Intermittent Set 1' : null;
    kod=="tv327" ? metin='Intermittent Set 2' : null;
    kod=="tv328" ? metin='Intermittent Set 3' : null;
    kod=="tv329" ? metin='On Time 1' : null;
    kod=="tv330" ? metin='On Time 2' : null;
    kod=="tv331" ? metin='Off Time 1' : null;
    kod=="tv332" ? metin='Off Time 2' : null;
    kod=="tv333" ? metin='On-Off Time 2\nActivity' : null;
    kod=="tv334" ? metin='Dimmer' : null;
    kod=="tv335" ? metin='Daytime Lig. Percent' : null;
    kod=="tv336" ? metin='Nighttime Lig. Percent' : null;
    kod=="tv337" ? metin='Sunrise-Sunset\nTime (Sec)' : null;
    kod=="tv338" ? metin='Hour' : null;
    kod=="tv339" ? metin='Minute' : null;
    kod=="tv340" ? metin='Light Percent(%)' : null;
    kod=="tv341" ? metin='Instant Light Percent(%)' : null;
    kod=="tv342" ? metin='Lighting Percent Diagram' : null;
    kod=="tv343" ? metin='Daytime Percent 1' : null;
    kod=="tv344" ? metin='Daytime Percent 2' : null;
    kod=="tv345" ? metin='Nighttime Percent 1' : null;
    kod=="tv346" ? metin='Nighttime Percent 2' : null;
    kod=="tv347" ? metin='HERD' : null;
    kod=="tv348" ? metin='CALIBRATION' : null;
    kod=="tv349" ? metin='Inputs' : null;
    kod=="tv350" ? metin='INPUTS' : null;
    kod=="tv351" ? metin='Input Assignments' : null;
    kod=="tv352" ? metin='Emer. Stop' : null;
    kod=="tv353" ? metin='Phase Cont.' : null;
    kod=="tv354" ? metin='Power Cur' : null;
    kod=="tv355" ? metin='Fan Fuse' : null;
    kod=="tv356" ? metin='Klp Fuse' : null;
    kod=="tv357" ? metin='Ped Fuse' : null;
    kod=="tv358" ? metin='Klp1 Open Swc' : null;
    kod=="tv359" ? metin='Klp2 Open Swc' : null;
    kod=="tv360" ? metin='Klp3 Open Swc' : null;
    kod=="tv361" ? metin='Klp4 Open Swc' : null;
    kod=="tv362" ? metin='Klp5 Open Swc' : null;
    kod=="tv363" ? metin='Klp6 Open Swc' : null;
    kod=="tv364" ? metin='Klp7 Open Swc' : null;
    kod=="tv365" ? metin='Klp8 Open Swc' : null;
    kod=="tv366" ? metin='Klp9 Open Swc' : null;
    kod=="tv367" ? metin='Klp10 Open Swc' : null;
    kod=="tv368" ? metin='Klp1 Close Swc' : null;
    kod=="tv369" ? metin='Klp2 Close Swc' : null;
    kod=="tv370" ? metin='Klp3 Close Swc' : null;
    kod=="tv371" ? metin='Klp4 Close Swc' : null;
    kod=="tv372" ? metin='Klp5 Close Swc' : null;
    kod=="tv373" ? metin='Klp6 Close Swc' : null;
    kod=="tv374" ? metin='Klp7 Close Swc' : null;
    kod=="tv375" ? metin='Klp8 Close Swc' : null;
    kod=="tv376" ? metin='Klp9 Close Swc' : null;
    kod=="tv377" ? metin='Klp10 Close Swc' : null;
    kod=="tv378" ? metin='Air1 Open Swc' : null;
    kod=="tv379" ? metin='Air2 Open Swc' : null;
    kod=="tv380" ? metin='Air1 Close Swc' : null;
    kod=="tv381" ? metin='Air2 Close Swc' : null;
    kod=="tv382" ? metin='A.Inlet Fuse' : null;
    kod=="tv383" ? metin='B.Fan Fuse' : null;
    kod=="tv384" ? metin='Isıtıcı Fuse' : null;
    kod=="tv385" ? metin='Sirk. Fuse' : null;
    kod=="tv386" ? metin='WaterMeter 1' : null;
    kod=="tv387" ? metin='WaterMeter 2' : null;
    kod=="tv388" ? metin='WaterMeter 3' : null;
    kod=="tv389" ? metin='WaterMeter 4' : null;
    kod=="tv390" ? metin='WaterMeter 5' : null;
    kod=="tv391" ? metin='WaterMeter 6' : null;
    kod=="tv392" ? metin='WaterMeter 7' : null;
    kod=="tv393" ? metin='WaterMeter 8' : null;
    kod=="tv394" ? metin='WaterMeter 9' : null;
    kod=="tv395" ? metin='WaterMeter 10' : null;
    kod=="tv396" ? metin='WaterMeter 11' : null;
    kod=="tv397" ? metin='WaterMeter 12' : null;
    kod=="tv398" ? metin='WaterMeter\nQuantity' : null;
    kod=="tv399" ? metin='Liter\nPer Pals' : null;
    kod=="tv400" ? metin='INSTALLATION' : null;
    kod=="tv401" ? metin='SYSTEM SETTINGS' : null;
    kod=="tv402" ? metin='TIME & DATE' : null;
    kod=="tv403" ? metin='TIME & DATE SETTINGS' : null;
    kod=="tv404" ? metin='YEAR' : null;
    kod=="tv405" ? metin='MONTH' : null;
    kod=="tv406" ? metin='DAY' : null;
    kod=="tv407" ? metin='HOUR' : null;
    kod=="tv408" ? metin='MINUTE' : null;
    kod=="tv409" ? metin='Hour Format\n00:00-23:59' : null;
    kod=="tv410" ? metin='Date Format 1\nDD-MM-YYYY' : null;
    kod=="tv411" ? metin='Date Format 1\nMM-DD-YYYY' : null;
    kod=="tv412" ? metin='CONFIRM TIME' : null;
    kod=="tv413" ? metin='CONFIRM DATE' : null;


    
    

    

    
    

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
    kod=="btn9" ? metin='Finish' : null;
    kod=="btn10" ? metin='ENTER' : null;
    

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
    kod=="toast6" ? metin='One of Flap no , X(m), Y(m) values or more are empty!' : null;
    kod=="toast7" ? metin='Invalid entry for x(m) or Y(m) value! Please check.' : null;
    kod=="toast8" ? metin='Successful' : null;
    kod=="toast9" ? metin='One or more Flaps dimensions must be defined!' : null;
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
    kod=="toast23" ? metin='One of Flap Control Method must be selected!' : null;
    kod=="toast24" ? metin='Please define Fan Number and Output number as nonzero for all selected fans' : null;
    kod=="toast25" ? metin='Same Fan Number assigned for two different fan! Please check.' : null;
    kod=="toast26" ? metin='Same Out Number assigned for two different out! Please check.' : null;
    kod=="toast27" ? metin='Please firstly send defined data!' : null;
    kod=="toast28" ? metin='Same Flap Number assigned for two different klepe! Please check.' : null;
    kod=="toast29" ? metin='Number of selected klepes are less then the defined!' : null;
    kod=="toast30" ? metin='Number of selected klepes are more then the defined!' : null;
    kod=="toast31" ? metin='Same Temp. Sensor Number assigned for two different temp. sensor! Please check.' : null;
    kod=="toast32" ? metin='Same Ped Number assigned for two different ped! Please check.' : null;
    kod=="toast33" ? metin='Two of active sensors assigned same number! Please check.' : null;
    kod=="toast34" ? metin='Atleast one active sensor must be assigned!' : null;
    kod=="toast35" ? metin='Please define Temp. Sensor Number as nonzero for all selected temp sensors' : null;
    kod=="toast36" ? metin='Please define Ped Number and Output number as nonzero for all selected peds' : null;
    kod=="toast37" ? metin='Please define Flap Number and Output number as nonzero for all selected klepes' : null;
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
    kod=="toast68" ? metin='Şu anda zaten ilgili klepe için kalibrasyon devam ediyor.' : null;
    kod=="toast68" ? metin='Calibration already in progress for the flap!' : null;
    kod=="toast69" ? metin='Calibration is only active that the flap is in automatic mod' : null;
    kod=="toast70" ? metin='Calibration started...' : null;
    kod=="toast71" ? metin='Calibration stopped...' : null;
    kod=="toast72" ? metin='This parameter can be activated when "Intermittent Cycle Time" is 10 min ' : null;
    kod=="toast73" ? metin='The parameter changes are not sent to system!' : null;
    kod=="toast74" ? metin='Please firstly do active "On-Off Time 2 Activity" option!' : null;
    kod=="toast75" ? metin='It is passive while dimmer option is checked!' : null;
    kod=="toast76" ? metin='Please define an input number for all inputs!' : null;


    //endregion

    return metin;
  }


}