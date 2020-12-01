

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
    kod=="tv16" ? metin='Bacafan Var mı?' : null;
    kod=="tv17" ? metin='A.Inlet & Sirk. Fan' : null;
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
    kod=="tv43" ? metin='Aç:' : null;
    kod=="tv44" ? metin='Kp:' : null;
    kod=="tv45" ? metin='Ped:' : null;
    kod=="tv46" ? metin='PED NO' : null;
    kod=="tv47" ? metin='Ped Pompa Haritası' : null;
    kod=="tv48" ? metin='Isı Sensör Haritası' : null;
    kod=="tv49" ? metin='Isı Sensör No' : null;
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
    kod=="tv61" ? metin='Isı Sensör No Atama' : null;
    kod=="tv62" ? metin='ÇIKIŞLAR' : null;
    kod=="tv63" ? metin='Gr:' : null;
    kod=="tv64" ? metin='Bfan No' : null;
    kod=="tv65" ? metin='B.Fan\nÇıkış No' : null;
    kod=="tv66" ? metin='Dijital\nÇıkış' : null;
    kod=="tv67" ? metin='Analog\nÇıkış' : null;
    kod=="tv68" ? metin='Baca Fan Haritası' : null;
    kod=="tv69" ? metin='Bfan Grup Çıkış No' : null;
    kod=="tv70" ? metin='Dış Sıc. Sen.' : null;
    kod=="tv71" ? metin='Air Inlet & Sirk. Fanı' : null;
    kod=="tv72" ? metin='No:' : null;
    kod=="tv73" ? metin='Çkş:' : null;
    kod=="tv74" ? metin='A.INLET NO' : null;
    kod=="tv75" ? metin='Air:' : null;
    kod=="tv76" ? metin='Isıtıcı Haritası' : null;
    kod=="tv77" ? metin='Isıtıcı Gr-1 Çkş No' : null;
    kod=="tv78" ? metin='Isıtıcı Gr-2 Çkş No' : null;
    kod=="tv79" ? metin='Isıtıcı Gr-3 Çkş No' : null;
    kod=="tv80" ? metin='Isıtıcı Grup No' : null;
    kod=="tv81" ? metin='Oto-Man Detayları' : null;
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
    kod=="tv103" ? metin='LOG&GRAFİK' : null;
    kod=="tv104" ? metin='ALARM&UYARI' : null;
    kod=="tv105" ? metin='SİSTEM' : null;
    kod=="tv106" ? metin='KONTROL AYARLARI' : null;
    kod=="tv107" ? metin='SIC. & FAN' : null;
    kod=="tv108" ? metin='KLEPE' : null;
    kod=="tv109" ? metin='SOĞ. & NEM' : null;
    kod=="tv110" ? metin='MİN. HAV.' : null;
    kod=="tv111" ? metin='ISITMA' : null;
    kod=="tv112" ? metin='AYDINLATMA' : null;
    kod=="tv113" ? metin='YEMLEME' : null;
    kod=="tv114" ? metin='YARD. OPS.' : null;
    kod=="tv115" ? metin='Set Sıcaklığı' : null;
    kod=="tv116" ? metin='Doğal bölge bitiş sıcaklığı' : null;
    kod=="tv117" ? metin='Çapraz hav. bitiş sıcaklığı' : null;
    kod=="tv118" ? metin='Tünel hav. aktif alan' : null;
    kod=="tv119" ? metin='Çapraz hav. aktif alan' : null;
    kod=="tv120" ? metin='Doğ.Bölge-Min.Hav. Sürekli' : null;
    kod=="tv121" ? metin='Min.Hav. Fasılalı' : null;
    kod=="tv122" ? metin='Max. fan sıcaklığı' : null;
    kod=="tv123" ? metin='Sıcaklık Diyagramı' : null;
    kod=="tv124" ? metin='Navigatör Menü' : null;
    kod=="tv125" ? metin='Set Sıcaklığı (A)' : null;
    kod=="tv126" ? metin='Doğal Bölge Farkı (B)' : null;
    kod=="tv127" ? metin='FANLARIN SET SICAKLIKLARI (°C)' : null;
    kod=="tv128" ? metin='Çapraz Hav. Farkı (C)' : null;
    kod=="tv129" ? metin='Silo No' : null;
    kod=="tv130" ? metin='Max. Fan Farkı (H)' : null;
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
    kod=="tv194" ? metin='Aktüel Açıklık (%) :' : null;
    kod=="tv195" ? metin='Çalışan Fan Say. 1-2 :' : null;
    kod=="tv196" ? metin='Klepe Açıklık 1-2 :' : null;
    kod=="tv197" ? metin='Çalışan Fan Say. 3-4 :' : null;
    kod=="tv198" ? metin='Klepe Açıklık 3-4 :' : null;
    kod=="tv199" ? metin='Min.Hav. Açıklık (%) :' : null;
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
    kod=="tv214" ? metin='Klp Baş. Düş. Fan M.Modu :' : null;
    kod=="tv215" ? metin='Çalışma Sırası :' : null;
    kod=="tv216" ? metin='Min-Max. Açıklık (%) :' : null;
    kod=="tv217" ? metin='Klp Baş. Düşen\nFan Mik. Man' : null;
    kod=="tv217a" ? metin='Klp Baş. Düşen Fan Mik. Man' : null;
    kod=="tv218" ? metin='Max. Açıklık :' : null;
    kod=="tv219" ? metin='Min. Açıklık :' : null;
    kod=="tv220" ? metin='Oto' : null;
    kod=="tv221" ? metin='Man' : null;
    kod=="tv222" ? metin='Klp Baş. Düşen\nFan Sayısını Manuel Gir' : null;
    kod=="tv223" ? metin='Sıra1 Fan Say. Bitiş' : null;
    kod=="tv224" ? metin='Sıra2 Fan Say. Bitiş' : null;
    kod=="tv225" ? metin='Sıra 1 Min. Açıklık' : null;
    kod=="tv226" ? metin='Sıra 1 Max. Açıklık' : null;
    kod=="tv227" ? metin='Sıra 2 Min. Açıklık' : null;
    kod=="tv228" ? metin='Sıra 2 Max. Açıklık' : null;
    kod=="tv229" ? metin='Çalışma Sırası 1' : null;
    kod=="tv230" ? metin='Çalışma Sırası 2' : null;
    kod=="tv231" ? metin='Sıra2 Fan Say. Başl' : null;
    kod=="tv232" ? metin='Kalibrasyon\nBaşlat' : null;
    kod=="tv232a" ? metin='Kalibrasyon Başlat' : null;
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
    kod=="tv249" ? metin='SOĞUTMA VE NEM' : null;
    kod=="tv250" ? metin='Max. Nem (%)' : null;
    kod=="tv251" ? metin='Nem Fark (%)' : null;
    kod=="tv252" ? metin='Maximum Nem' : null;
    kod=="tv253" ? metin='Soğutma Diyagramı' : null;
    kod=="tv254" ? metin='Çalışma Sıcaklığı' : null;
    kod=="tv255" ? metin='Durma Sıcaklığı' : null;
    kod=="tv256" ? metin='Ped P. Pasif Alan' : null;
    kod=="tv257" ? metin='Ped P. kısmi Aktif Alan' : null;
    kod=="tv258" ? metin='Ped P. Aktif Alan' : null;
    kod=="tv259" ? metin='Max. Nem Pasif Alan' : null;
    kod=="tv260" ? metin='Max. Nem kısmi Aktif Alan' : null;
    kod=="tv261" ? metin='Max. Nem Aktif Alan' : null;
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
    kod=="tv272" ? metin='Fasılada Max.\nÇalışma Yüzdesi(%)' : null;
    kod=="tv272a" ? metin='Fasılada Max. Çalışma Yüzdesi(%)' : null;
    kod=="tv273" ? metin='Air Inlet\nÖncelik Süresi(Sn)' : null;
    kod=="tv273a" ? metin='Air Inlet Öncelik Süresi(Sn)' : null;
    kod=="tv274" ? metin='Hava Giriş\nYüzdesi(%)' : null;
    kod=="tv274a" ? metin='Hava Giriş Yüzdesi(%)' : null;
    kod=="tv275" ? metin='Fasıla Durma\'da Air Inlet Kapansın mı?' : null;
    kod=="tv276" ? metin='MİNİMUM HAVALANDIRMA' : null;
    kod=="tv277" ? metin='Min. Hav.\nFan Sayısı' : null;
    kod=="tv278" ? metin='Hayv. Başına\nihtiyaç(m3/h)' : null;
    kod=="tv279" ? metin='Hayvan Başına Min. Hav. İhtiyacı(m3/h)' : null;
    kod=="tv280" ? metin='1-7 Gün' : null;
    kod=="tv281" ? metin='8-14 Gün' : null;
    kod=="tv282" ? metin='15-21 Gün' : null;
    kod=="tv283" ? metin='22-28 Gün' : null;
    kod=="tv284" ? metin='29-35 Gün' : null;
    kod=="tv285" ? metin='36-42 Gün' : null;
    kod=="tv286" ? metin='43-49 Gün' : null;
    kod=="tv287" ? metin='50 ve Sonrası' : null;
    kod=="tv288" ? metin='Default Değerlere Dön' : null;
    kod=="tv289" ? metin='Tünel Fan KW' : null;
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
    kod=="tv303" ? metin='Fan Kontrol Yöntemi' : null;
    kod=="tv304" ? metin='MH Kontrol Yöntemi' : null;
    kod=="tv305" ? metin='Klepe Motor KW' : null;
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
    kod=="tv333a" ? metin='Aç-Kapa Saati 2 Aktif' : null;
    kod=="tv334" ? metin='Dimmer' : null;
    kod=="tv335" ? metin='Gündüz-Gece Aydınlık Yüzdesi 1' : null;
    kod=="tv336" ? metin='Gündüz-Gece Aydınlık Yüzdesi 2' : null;
    kod=="tv337" ? metin='Doğuş-Batış\nSüresi (Sn)' : null;
    kod=="tv337a" ? metin='Doğuş-Batış Süresi (Sn)' : null;
    kod=="tv338" ? metin='Saat' : null;
    kod=="tv339" ? metin='Dakika' : null;
    kod=="tv340" ? metin='Ayd. Yüzdesi(%)' : null;
    kod=="tv341" ? metin='Anlık Ayd. Yüzdesi(%)' : null;
    kod=="tv342" ? metin='Ped Pompa KW' : null;
    kod=="tv343" ? metin='Gündüz Yüzdesi 1' : null;
    kod=="tv344" ? metin='Gündüz Yüzdesi 2' : null;
    kod=="tv345" ? metin='Gece Yüzdesi 1' : null;
    kod=="tv346" ? metin='Gece Yüzdesi 2' : null;
    kod=="tv347" ? metin='SÜRÜ' : null;
    kod=="tv348" ? metin='KALİBRASYON' : null;
    kod=="tv349" ? metin='Girişler' : null;
    kod=="tv350" ? metin='Bfan Motorları KW ' : null;
    kod=="tv351" ? metin='Girişlerin Atanması' : null;
    kod=="tv352" ? metin='Acil\nStop' : null;
    kod=="tv353" ? metin='Faz\nKoruma' : null;
    kod=="tv354" ? metin='Elektrik\nKesildi' : null;
    kod=="tv355" ? metin='Fan\nTermik' : null;
    kod=="tv356" ? metin='Klepe\nTermik' : null;
    kod=="tv357" ? metin='Ped\nTermik' : null;
    kod=="tv358" ? metin='Klepe1\nAç Swç' : null;
    kod=="tv359" ? metin='Klepe2\nAç Swç' : null;
    kod=="tv360" ? metin='Klepe3\nAç Swç' : null;
    kod=="tv361" ? metin='Klepe4\nAç Swç' : null;
    kod=="tv362" ? metin='Klepe5\nAç Swç' : null;
    kod=="tv363" ? metin='Klepe6\nAç Swç' : null;
    kod=="tv364" ? metin='Klepe7\nAç Swç' : null;
    kod=="tv365" ? metin='Klepe8\nAç Swç' : null;
    kod=="tv366" ? metin='Klepe9\nAç Swç' : null;
    kod=="tv367" ? metin='Klepe10\nAç Swç' : null;
    kod=="tv368" ? metin='Klepe1\nKapa Swç' : null;
    kod=="tv369" ? metin='Klepe2\nKapa Swç' : null;
    kod=="tv370" ? metin='Klepe3\nKapa Swç' : null;
    kod=="tv371" ? metin='Klepe4\nKapa Swç' : null;
    kod=="tv372" ? metin='Klepe5\nKapa Swç' : null;
    kod=="tv373" ? metin='Klepe6\nKapa Swç' : null;
    kod=="tv374" ? metin='Klepe7\nKapa Swç' : null;
    kod=="tv375" ? metin='Klepe8\nKapa Swç' : null;
    kod=="tv376" ? metin='Klepe9\nKapa Swç' : null;
    kod=="tv377" ? metin='Klepe10\nKapa Swç' : null;
    kod=="tv378" ? metin='Air Inlet\nAç Swç' : null;
    kod=="tv379" ? metin='Air Inlet\nkapa Swç' : null;
    kod=="tv380" ? metin='Bacafan\nAç Swç' : null;
    kod=="tv381" ? metin='Bacafan\nKapa Swç' : null;
    kod=="tv382" ? metin='Air Inlet\nTermik' : null;
    kod=="tv383" ? metin='Bacafan\nTermik' : null;
    kod=="tv384" ? metin='Isıtıcı \nTermik' : null;
    kod=="tv385" ? metin='Sirk. Fan\nTermik' : null;
    kod=="tv386" ? metin='Su\nSayacı 1' : null;
    kod=="tv387" ? metin='Su\nSayacı 2' : null;
    kod=="tv388" ? metin='Su\nSayacı 3' : null;
    kod=="tv389" ? metin='Su\nSayacı 4' : null;
    kod=="tv390" ? metin='Su\nSayacı 5' : null;
    kod=="tv391" ? metin='Su\nSayacı 6' : null;
    kod=="tv392" ? metin='Su\nSayacı 7' : null;
    kod=="tv393" ? metin='Su\nSayacı 8' : null;
    kod=="tv394" ? metin='Su\nSayacı 9' : null;
    kod=="tv395" ? metin='Su\nSayacı 10' : null;
    kod=="tv396" ? metin='Su\nSayacı 11' : null;
    kod=="tv397" ? metin='Su\nSayacı 12' : null;
    kod=="tv398" ? metin='Su Sayaç\nSayısı' : null;
    kod=="tv399" ? metin='Pals Başına\nLitre' : null;
    kod=="tv400" ? metin='KURULUM' : null;
    kod=="tv401" ? metin='SİSTEM AYARLARI' : null;
    kod=="tv402" ? metin='SAAT & TARİH' : null;
    kod=="tv403" ? metin='SAAT & TARİH AYARLARI' : null;
    kod=="tv404" ? metin='YIL' : null;
    kod=="tv405" ? metin='AY' : null;
    kod=="tv406" ? metin='GÜN' : null;
    kod=="tv407" ? metin='SAAT DİLİMİ' : null;
    kod=="tv408" ? metin='DAKİKA' : null;
    kod=="tv409" ? metin='Saat Formatı\n00:00-23:59' : null;
    kod=="tv410" ? metin='Tarih Formatı 1\nGG-AA-YYYY' : null;
    kod=="tv411" ? metin='Tarih Formatı 1\nAA-GG-YYYY' : null;
    kod=="tv412" ? metin='SAATİ ONAYLA' : null;
    kod=="tv413" ? metin='TARİHİ ONAYLA' : null;
    kod=="tv414" ? metin='SÜRÜ BİLGİLERİ' : null;
    kod=="tv415" ? metin='Sürü Doğum\nTarihi' : null;
    kod=="tv415a" ? metin='Sürü Doğum Tarihi' : null;
    kod=="tv416" ? metin='Sürü Giriş\nTarihi' : null;
    kod=="tv416a" ? metin='Sürü Giriş Tarihi' : null;
    kod=="tv417" ? metin='Hayvan Sayısı\n(girişte)' : null;
    kod=="tv417a" ? metin='Hayvan Sayısı (girişte)' : null;
    kod=="tv418" ? metin='Ölüm\nSayısı' : null;
    kod=="tv419" ? metin='Kategorilere Göre Ölü Hayvan Sayısı Girişi' : null;
    kod=="tv420" ? metin='Hastalık Kaynaklı' : null;
    kod=="tv421" ? metin='Ekipman Kaynaklı' : null;
    kod=="tv422" ? metin='Hayv. Saldırısı Kaynaklı' : null;
    kod=="tv423" ? metin='Havalandırma Kaynaklı' : null;
    kod=="tv424" ? metin='Yem Kaynaklı' : null;
    kod=="tv425" ? metin='Su Kaynaklı' : null;
    kod=="tv426" ? metin='Ölüm\nOranı (%)' : null;
    kod=="tv427" ? metin='Güncel Hayvan\nSayısı' : null;
    kod=="tv428" ? metin='Sürü Yaşı\n(Günlük)' : null;
    kod=="tv429" ? metin='Sürü Yaşı\n(Haftalık)' : null;
    kod=="tv430" ? metin='Harici Alarm' : null;
    kod=="tv431" ? metin='SENSÖR KALİBRASYONU' : null;
    kod=="tv432" ? metin='Nem. Sen. Ölçüm Yöntemi' : null;
    kod=="tv433" ? metin='Wifi' : null;
    kod=="tv434" ? metin='Analog' : null;
    kod=="tv435" ? metin='Isı Sensörleri' : null;
    kod=="tv436" ? metin='Artı-Eksi Sensor Kalibrasyon Değeri Gir' : null;
    kod=="tv437" ? metin='Sıcaklık\nDeğeri (°C)' : null;
    kod=="tv438" ? metin='+ Değer' : null;
    kod=="tv439" ? metin='- Değer' : null;
    kod=="tv440" ? metin='Nem Sensörleri' : null;
    kod=="tv441" ? metin='İç Nem' : null;
    kod=="tv441a" ? metin='İç\nNem' : null;
    kod=="tv442" ? metin='Dış Nem' : null;
    kod=="tv443" ? metin='Analog1' : null;
    kod=="tv444" ? metin='Analog2' : null;
    kod=="tv445" ? metin='Analog3' : null;
    kod=="tv446" ? metin='Analog4' : null;
    kod=="tv447" ? metin='Analog5' : null;
    kod=="tv448" ? metin='Analog6' : null;
    kod=="tv449" ? metin='Analog7' : null;
    kod=="tv450" ? metin='Analog8' : null;
    kod=="tv451" ? metin='Analog9' : null;
    kod=="tv452" ? metin='Analog10' : null;
    kod=="tv453" ? metin='Sensör Kalibrasyon Detayları' : null;
    kod=="tv454" ? metin='OTOMATİK-MANUEL SEÇİMİ' : null;
    kod=="tv455" ? metin='OTO' : null;
    kod=="tv456" ? metin='MAN' : null;
    kod=="tv457" ? metin='MAN Kontrol' : null;
    kod=="tv458" ? metin='T.FAN' : null;
    kod=="tv459" ? metin='PED POMPA' : null;
    kod=="tv460" ? metin='AIR INLET' : null;
    kod=="tv461" ? metin='BACA FAN' : null;
    kod=="tv462" ? metin='ISITICI' : null;
    kod=="tv463" ? metin='YEM ARABA' : null;
    kod=="tv464" ? metin='TÜNEL FANLARININ MANUEL KONTROLÜ' : null;
    kod=="tv465" ? metin='PED POMPALARININ MANUEL KONTROLÜ' : null;
    kod=="tv466" ? metin='AYDINLATMA SİSTEMİNİN MANUEL KONTROLÜ' : null;
    kod=="tv467" ? metin='BACA FANLARININ MANUEL KONTROLÜ' : null;
    kod=="tv468" ? metin='ISITICILARIN MANUEL KONTROLÜ' : null;
    kod=="tv469" ? metin='YEM ARABALARININ MANUEL KONTROLÜ' : null;
    kod=="tv470" ? metin='Manuel Aydınlık Yüzdesi (%)' : null;
    kod=="tv471" ? metin='MANUEL KONTROL' : null;
    kod=="tv472" ? metin='Klepe Hareket Süresi (Sn)' : null;
    kod=="tv473" ? metin='AÇ' : null;
    kod=="tv474" ? metin='KAPA' : null;
    kod=="tv475" ? metin='KLEPE OTO-MAN SEÇİMİ' : null;
    kod=="tv476" ? metin='AIR INLET OTO-MAN SEÇİMİ' : null;
    kod=="tv477" ? metin='Air Inlet Hareket Süresi (Sn)' : null;
    kod=="tv478" ? metin='İlk Kaç Gün Sadece\nMin.Hav. Yapsın?' : null;
    kod=="tv478a" ? metin='İlk Kaç Gün Sadece Min.Hav. Yapsın?' : null;
    kod=="tv479" ? metin='Sadece Min. Hav.\nModu Aktif' : null;
    kod=="tv479a" ? metin='Sadece Min. Hav. Modu Aktif' : null;
    kod=="tv480" ? metin='Min. Hav.\'dan Geçişte\nDebi Korunsun mu?' : null;
    kod=="tv480a" ? metin='Min. Hav.\'dan Geçişte Debi Korunsun mu?' : null;
    kod=="tv481" ? metin='YARDIMCI OPSİYONLAR' : null;
    kod=="tv482" ? metin='Min. Nem (%)' : null;
    kod=="tv483" ? metin='Sıcaklık-Açıklık Diyagramı' : null;
    kod=="tv484" ? metin='Minimum Nem' : null;
    kod=="tv485" ? metin='Dusuk Nemde\nPed Çalışsın' : null;
    kod=="tv485a" ? metin='Dusuk Nemde Ped Çalışsın' : null;
    kod=="tv486" ? metin='Sıc. Öncelikli' : null;
    kod=="tv487" ? metin='Ped P. 1' : null;
    kod=="tv488" ? metin='Ped P. 2-3' : null;
    kod=="tv489" ? metin='Yüksek Nemde\nTüm Fanlar Çalışsın' : null;
    kod=="tv489a" ? metin='Yüksek Nemde Tüm Fanlar Çalışsın' : null;
    kod=="tv490" ? metin='Dış Nem\nÜst Limit Aktif' : null;
    kod=="tv490a" ? metin='Dış Nem Üst Limit Aktif' : null;
    kod=="tv491" ? metin='Dış Nem\nÜst Limit' : null;
    kod=="tv491a" ? metin='Dış Nem Üst Limit' : null;
    kod=="tv492" ? metin='0-10V' : null;
    kod=="tv493" ? metin='4-20mA' : null;
    kod=="tv494" ? metin='Bacafan\nMotor Hızı (Hz)' : null;
    kod=="tv495" ? metin='Baca Fanları' : null;
    kod=="tv496" ? metin='OPSİYON 1' : null;
    kod=="tv497" ? metin='OPSİYON 2' : null;
    kod=="tv498" ? metin='Yakın Sıcaklık Sensörlerine\nGöre Klepe Kontrolü' : null;
    kod=="tv499" ? metin='AYARLARI GİR' : null;
    kod=="tv500" ? metin='SENSÖR KLEPE KONTROL' : null;
    kod=="tv501" ? metin='Sıcaklık Farkı(°C)' : null;
    kod=="tv502" ? metin='Sens. No1' : null;
    kod=="tv503" ? metin='Sens. No2' : null;
    kod=="tv504" ? metin='Set Sıc.- Sıc. Farkı' : null;
    kod=="tv505" ? metin='Mevcut Klepe Açıklığı' : null;
    kod=="tv506" ? metin='00:00' : null;
    kod=="tv507" ? metin='00:30' : null;
    kod=="tv508" ? metin='01:00' : null;
    kod=="tv509" ? metin='01:30' : null;
    kod=="tv510" ? metin='02:00' : null;
    kod=="tv511" ? metin='02:30' : null;
    kod=="tv512" ? metin='03:00' : null;
    kod=="tv513" ? metin='03:30' : null;
    kod=="tv514" ? metin='04:00' : null;
    kod=="tv515" ? metin='04:30' : null;
    kod=="tv516" ? metin='05:00' : null;
    kod=="tv517" ? metin='05:30' : null;
    kod=="tv518" ? metin='06:00' : null;
    kod=="tv519" ? metin='06:30' : null;
    kod=="tv520" ? metin='07:00' : null;
    kod=="tv521" ? metin='07:30' : null;
    kod=="tv522" ? metin='08:00' : null;
    kod=="tv523" ? metin='08:30' : null;
    kod=="tv524" ? metin='09:00' : null;
    kod=="tv525" ? metin='09:30' : null;
    kod=="tv526" ? metin='10:00' : null;
    kod=="tv527" ? metin='10:30' : null;
    kod=="tv528" ? metin='11:00' : null;
    kod=="tv529" ? metin='11:30' : null;
    kod=="tv530" ? metin='12:00' : null;
    kod=="tv531" ? metin='12:30' : null;
    kod=="tv532" ? metin='13:00' : null;
    kod=="tv533" ? metin='13:30' : null;
    kod=="tv534" ? metin='14:00' : null;
    kod=="tv535" ? metin='14:30' : null;
    kod=="tv536" ? metin='15:00' : null;
    kod=="tv537" ? metin='15:30' : null;
    kod=="tv538" ? metin='16:00' : null;
    kod=="tv539" ? metin='16:30' : null;
    kod=="tv540" ? metin='17:00' : null;
    kod=="tv541" ? metin='17:30' : null;
    kod=="tv542" ? metin='18:00' : null;
    kod=="tv543" ? metin='18:30' : null;
    kod=="tv544" ? metin='19:00' : null;
    kod=="tv545" ? metin='19:30' : null;
    kod=="tv546" ? metin='20:00' : null;
    kod=="tv547" ? metin='20:30' : null;
    kod=="tv548" ? metin='21:00' : null;
    kod=="tv549" ? metin='21:30' : null;
    kod=="tv550" ? metin='22:00' : null;
    kod=="tv551" ? metin='22:30' : null;
    kod=="tv552" ? metin='23:00' : null;
    kod=="tv553" ? metin='23:30' : null;
    kod=="tv554" ? metin='YEM ÇIKIŞ 1' : null;
    kod=="tv555" ? metin='YEM ÇIKIŞ 2' : null;
    kod=="tv556" ? metin='YEM ÇIKIŞ 3' : null;
    kod=="tv557" ? metin='İleri' : null;
    kod=="tv558" ? metin='Geri' : null;
    kod=="tv559" ? metin='YEMLEME ZAMANI ATAMA' : null;
    kod=="tv560" ? metin='Yemleme Detayları' : null;
    kod=="tv561" ? metin='Sinyal Süresi (Sn) : ' : null;
    kod=="tv562" ? metin='Otomatikte Devreye Giren Tünel\nFanlarının Min. Çalş. Süresi (Sn)' : null;
    kod=="tv562a" ? metin='Otomatikte Devreye Giren Tünel Fanlarının Min. Çalş. Süresi (Sn)' : null;
    kod=="tv563" ? metin='Yeni şifreyi onaylamadınız!\nYine de çıkmak istiyor musunuz?' : null;
    kod=="tv564" ? metin='Yapılan değişiklikleri göndermediniz!\nYine de çıkmak istiyor musunuz?' : null;
    kod=="tv565" ? metin='OPSİYON 4' : null;
    kod=="tv566" ? metin='Elek. Kesildiğinde\nSistemi Durdur' : null;
    kod=="tv566a" ? metin='Elek. Kesildiğinde Sistemi Durdur' : null;
    kod=="tv567" ? metin='T.Fan. Yumuşak\nGeçiş Döngüsü(Sn)' : null;
    kod=="tv567a" ? metin='T.Fan. Yumuşak Geçiş Döngüsü(Sn)' : null;
    kod=="tv568" ? metin='T.Fan. Yumuşak\nGeçiş Adedi' : null;
    kod=="tv568a" ? metin='T.Fan. Yumuşak Geçiş Adedi' : null;
    kod=="tv569" ? metin='SİSTEM İZLEME' : null;
    kod=="tv570" ? metin='Tünel Fanları' : null;
    kod=="tv571" ? metin='MOD' : null;
    kod=="tv572" ? metin='Sistem Kapalı' : null;
    kod=="tv573" ? metin='Min. Hav. Fasılalı' : null;
    kod=="tv574" ? metin='Min. Hav. Sürekli' : null;
    kod=="tv575" ? metin='Çapraz Havalandırma' : null;
    kod=="tv576" ? metin='Tünel Havalandırma' : null;
    kod=="tv577" ? metin='Yüksek Nem' : null;
    kod=="tv578" ? metin='Düşük Nem' : null;
    kod=="tv579" ? metin='Çal:' : null;
    kod=="tv580" ? metin='Dur:' : null;
    kod=="tv581" ? metin='Sirk. Fan' : null;
    kod=="tv582" ? metin='Set\nSıc' : null;
    kod=="tv583" ? metin='Ort\nSıc' : null;
    kod=="tv584" ? metin='Doğ.B.Bitiş' : null;
    kod=="tv585" ? metin='Çap.B.Bitiş' : null;
    kod=="tv586" ? metin='Air Inlet' : null;
    kod=="tv587" ? metin='A.In.1' : null;
    kod=="tv588" ? metin='A.In.2' : null;
    kod=="tv589" ? metin='Durum' : null;
    kod=="tv590" ? metin='Açık' : null;
    kod=="tv591" ? metin='Kapalı' : null;
    kod=="tv592" ? metin='Isıtıcı' : null;
    kod=="tv593" ? metin='Gr. 1:' : null;
    kod=="tv594" ? metin='Gr. 2:' : null;
    kod=="tv595" ? metin='Gr. 3:' : null;
    kod=="tv596" ? metin='Açılıyor' : null;
    kod=="tv597" ? metin='Kapanıyor:' : null;
    kod=="tv598" ? metin='İZLEME-1' : null;
    kod=="tv599" ? metin='İZLEME-2' : null;
    kod=="tv600" ? metin='S1:' : null;//Silo 1
    kod=="tv601" ? metin='S2:' : null;//Silo 1
    kod=="tv602" ? metin='S3:' : null;//Silo 1
    kod=="tv603" ? metin='S4:' : null;//Silo 1
    kod=="tv604" ? metin='Kg' : null;
    kod=="tv605" ? metin='Günlük\nToplam\nTük.(Kg)' : null;
    kod=="tv606" ? metin='Günlük\nHay.Baş\nTük.(Gr)' : null;
    kod=="tv607" ? metin='Bir sonraki\nYemleme Zamanı' : null;
    kod=="tv608" ? metin='Etkin Aç-Kapa\nSaatleri' : null;
    kod=="tv609" ? metin='SU SAYACLARI' : null;
    kod=="tv610" ? metin='Su Tüketimleri(Lt)' : null;
    kod=="tv611" ? metin='Gün. Topl.Tük:' : null;
    kod=="tv612" ? metin='Gün. Hay.Baş:' : null;
    kod=="tv613" ? metin='Ayd. Yüz.(%):' : null;
    kod=="tv614" ? metin='Ölç.Max.OSıc' : null;
    kod=="tv615" ? metin='Ölç.Min.OSıc' : null;
    kod=="tv616" ? metin='Max.OSic.Saati' : null;
    kod=="tv617" ? metin='Min.OSic.Saati' : null;
    kod=="tv618" ? metin='İç Nem' : null;
    kod=="tv619" ? metin='Dış Nem' : null;
    kod=="tv620" ? metin='Ort.Hissed.Sıc.' : null;
    kod=="tv621" ? metin='Sistemde\nyemleme\nçıkışları\naktif değil!' : null;
    kod=="tv622" ? metin='Sistemde\nsu sayac\ngirişleri\naktif değil!' : null;
    kod=="tv623" ? metin='Sistemde\nyem silo ağırlık\nokumaları\naktif değil!' : null;
    kod=="tv624" ? metin='Bacafan\nKapak\nVar mı?' : null;
    kod=="tv625" ? metin='Kapak Aç\nÇıkış No' : null;
    kod=="tv626" ? metin='Kapak Kapa\nÇıkış No' : null;
    kod=="tv627" ? metin='Sirk. Fan\nÇıkış No' : null;
    kod=="tv628" ? metin='Air Aç\nÇıkış No' : null;
    kod=="tv629" ? metin='Air Kapa\nÇıkış No' : null;
    kod=="tv630" ? metin='Adetler kısmında\nSirk. Fan\nseçili değil!' : null;
    kod=="tv631" ? metin='Adetler kısmında\nAir Inlet\nseçili değil!' : null;
    kod=="tv632" ? metin='YemAraba\nTermik' : null;
    kod=="tv633" ? metin='Ayd.\nSigorta' : null;
    kod=="tv634" ? metin='Fan Haritası Yükleniyor...' : null;
    kod=="tv635" ? metin='Klepe Haritası Yükleniyor...' : null;
    kod=="tv636" ? metin='Çıkışlar Yükleniyor...' : null;
    kod=="tv637" ? metin='Su\nAlarm' : null;
    kod=="tv638" ? metin='Girişler Yükleniyor...' : null;
    kod=="tv639" ? metin='YEM SİLOLARI' : null;
    kod=="tv640" ? metin='YOK' : null;
    kod=="tv641" ? metin='FAN - KLEPE' : null;
    kod=="tv642" ? metin='SIC. SEN. - PED' : null;
    kod=="tv643" ? metin='B.FANI - AIR. IN.' : null;
    kod=="tv644" ? metin='SİRK. FANI - ISITICI' : null;
    kod=="tv645" ? metin='YEMLEME - AYD.' : null;
    kod=="tv646" ? metin='S.SAYACI - SILO' : null;
    kod=="tv647" ? metin='İZLEME-3' : null;
    kod=="tv648" ? metin='Oto Atama Hangi Çıkıştan Başlasın?' : null;
    kod=="tv649" ? metin='BACA FANLARI' : null;
    kod=="tv650" ? metin='ISITICILAR' : null;
    kod=="tv651" ? metin='Motor Hızı(Hz): ' : null;
    kod=="tv652" ? metin='Kalan Süre(Sn): ' : null;
    kod=="tv653" ? metin='SİRK.FANI' : null;
    kod=="tv654" ? metin='SİRK: FANLARININ MANUEL KONTROLÜ' : null;
    kod=="tv655" ? metin='Kalan' : null;
    kod=="tv656" ? metin='Sistemde Air Inlet\naktif değil!' : null;
    kod=="tv657" ? metin='Sistemde\nBacafan\naktif değil!' : null;
    kod=="tv658" ? metin='Sistemde\nIsıtıcı\naktif değil!' : null;
    kod=="tv659" ? metin='Sistemde\nYemleme\naktif değil!' : null;
    kod=="tv660" ? metin='Sistemde\nSirk. Fan\naktif değil!' : null;
    kod=="tv661" ? metin='Ortalama Sıcaklık' : null;
    kod=="tv661a" ? metin='Ortalama\nSıcaklık' : null;
    kod=="tv662" ? metin='Hava Hızı (m/sn)' : null;
    kod=="tv663" ? metin='OPSİYON 5' : null;
    kod=="tv664" ? metin='KW Değerleri' : null;
    kod=="tv665" ? metin='Ölç.Max. Nem' : null;
    kod=="tv666" ? metin='Ölç.Min. Nem' : null;
    kod=="tv667" ? metin='Max.Nem Saati' : null;
    kod=="tv668" ? metin='Min.Nem Saati' : null;
    kod=="tv669" ? metin='OPSİYON 6' : null;
    kod=="tv670" ? metin='Günlük Ölçülen Min-Max Sıc. ve Nem\nDeğerleri Reset Zamanı' : null;
    kod=="tv670a" ? metin='Günlük Ölçülen Min-Max Sıc. ve Nem Değerleri Reset Zamanı(Dk)' : null;
    kod=="tv670b" ? metin='Günlük Ölçülen Min-Max Sıc. ve Nem Değerleri Reset Zamanı(Saat)' : null;
    kod=="tv671" ? metin='OPSİYON 7' : null;
    kod=="tv672" ? metin='Günlük Yem, Su ve Elektrik\nTüketim Verileri Reset Zamanı' : null;
    kod=="tv672a" ? metin='Günlük Yem, Su ve Elektrik Tüketim Verileri Reset Zamanı (Dk)' : null;
    kod=="tv672b" ? metin='Günlük Yem, Su ve Elektrik Tüketim Verileri Reset Zamanı (Saat)' : null;
    kod=="tv673" ? metin='KISALTMALAR:' : null;
    kod=="tv674" ? metin='Ölüm Oranı (%)' : null;
    kod=="tv675" ? metin='Güncel Hayvan Sayısı' : null;
    kod=="tv676" ? metin='OPSİYON 3' : null;
    kod=="tv677" ? metin='YAZILIM' : null;
    kod=="tv678" ? metin='Yazılım Tanımı' : null;
    kod=="tv679" ? metin='Programlanabilir Kümes İklimlendirme Sistemi\nLokal Pano Ekran Yazılımı' : null;
    kod=="tv680" ? metin='Yazılım İsmi' : null;
    kod=="tv681" ? metin='PROKIS CORE' : null;
    kod=="tv682" ? metin='Versiyon Numarası' : null;
    kod=="tv683" ? metin='PCV 1.0.0' : null;
    kod=="tv684" ? metin='SİSTEM START-STOP' : null;
    kod=="tv685" ? metin='Sistemi Çalıştır veya Durdur' : null;
    kod=="tv686" ? metin='Sistem Durumu' : null;
    kod=="tv687" ? metin='SİSTEM ÇALIŞIYOR' : null;
    kod=="tv688" ? metin='SİSTEM DURUYOR' : null;
    kod=="tv689" ? metin='Kurulum Revizyon Numarası' : null;
    kod=="tv690" ? metin='SİSTEM\nSTART-STOP' : null;
    kod=="tv691" ? metin='BAĞLANTI DURUMU' : null;
    kod=="tv692" ? metin='Bağlantı hatası!' : null;
    kod=="tv693" ? metin='Bağlantı zaman aşımına uğradı!' : null;
    kod=="tv694" ? metin='Bağlantı reddedildi!' : null;
    kod=="tv695" ? metin='HATAYI RESETLE' : null;
    kod=="tv696" ? metin='Diğer/Tanımsız bir hata oluştu!' : null;
    kod=="tv697" ? metin='PLC ve Server PC arasındaki bağlantı kaptu!' : null;
    kod=="tv698" ? metin='Hata Kodu' : null;
    kod=="tv699" ? metin='Min. Sıc.(°C)' : null;
    kod=="tv700" ? metin='Max. Sıc.(°C)' : null;
    kod=="tv701" ? metin='7 HAFTALIK ALARM MİN. & MAX SICAKLIK TANIMLAMASI' : null;
    kod=="tv702" ? metin='ALARM AYARLARI' : null;
    kod=="tv703" ? metin='Min: ' : null;
    kod=="tv704" ? metin='Max: ' : null;
    kod=="tv705" ? metin='MIN' : null;
    kod=="tv706" ? metin='MAX' : null;
    kod=="tv707" ? metin='SET' : null;
    kod=="tv708" ? metin='Set: ' : null;
    kod=="tv709" ? metin='Ara\nDeğerleri\nGöster' : null;
    kod=="tv710" ? metin='Alarm Gecikmesi (Sn)\n(Min-Max değerler için)' : null;
    kod=="tv710a" ? metin='Alarm Gecikmesi (Sn) (Min-Max değerler için)' : null;
    kod=="tv711" ? metin='Günlük Min. Tük.(Lt)\n(1 sayaç için)' : null;
    kod=="tv711a" ? metin='Günlük Min. Tük.(Lt) (1 sayaç için)' : null;
    kod=="tv712" ? metin='Ped Bakım Zamanı\nDöngü Süresi(Gün)' : null;
    kod=="tv712a" ? metin='Ped Bakım Zamanı Döngü Süresi(Gün)' : null;
    kod=="tv713" ? metin='Sistem Bakım Zamanı\nDöngü Süresi(Gün)' : null;
    kod=="tv713a" ? metin='Sistem Bakım Zamanı Döngü Süresi(Gün)' : null;
    kod=="tv714" ? metin='Kornayı Sustur' : null;
    kod=="tv715" ? metin='Susma Süresi(Sn)' : null;
    kod=="tv716" ? metin='Alarm Korna İptal' : null;
    kod=="tv717" ? metin='ALARM & UYARI DURUM' : null;
    kod=="tv718" ? metin='ALARMI KALDIR' : null;
    kod=="tv719" ? metin='UYARIYI KALDIR' : null;
    kod=="tv720" ? metin='ALARM DETAYLARI' : null;
    kod=="tv721" ? metin='HATA DETAYLARI' : null;
    kod=="tv722" ? metin='Harici Alarmlar' : null;
    kod=="tv723" ? metin='HARİCİ ALARMLAR' : null;
    kod=="tv724" ? metin='Alarmı listeden silmek istediğinize emin misiniz?' : null;
    kod=="tv725" ? metin='Yeni harici alarm metni ekle...' : null;
    kod=="tv726" ? metin='ALARM KORNA İPTAL' : null;
    kod=="tv727" ? metin='LİSTEYİ GÜNCELLE' : null;
    kod=="tv728" ? metin='LOG VE GRAFİK' : null;
    kod=="tv729" ? metin='DATA LOGLAR' : null;
    kod=="tv730" ? metin='GRAFİKLER' : null;
    kod=="tv731" ? metin='SIC. & NEM\nLOGLARI' : null;
    kod=="tv732" ? metin='ALARM / UYARI\nLOGLARI' : null;
    kod=="tv733" ? metin='TÜKETİM\nLOGLARI' : null;
    kod=="tv734" ? metin='PARAMETRE\nLOGLARI' : null;
    kod=="tv735" ? metin='SIC. & NEM LOGLARI' : null;
    kod=="tv736" ? metin='ALARM / UYARI LOGLARI' : null;
    kod=="tv737" ? metin='TÜKETİM LOGLARI' : null;
    kod=="tv738" ? metin='PARAMETRE LOGLARI' : null;
    kod=="tv739" ? metin='Sıc. Sensör 1' : null;
    kod=="tv740" ? metin='Sıc. Sensör 2' : null;
    kod=="tv741" ? metin='Sıc. Sensör 3' : null;
    kod=="tv742" ? metin='Sıc. Sensör 4' : null;
    kod=="tv743" ? metin='Sıc. Sensör 5' : null;
    kod=="tv744" ? metin='Sıc. Sensör 6' : null;
    kod=="tv745" ? metin='Sıc. Sensör 7' : null;
    kod=="tv746" ? metin='Sıc. Sensör 8' : null;
    kod=="tv747" ? metin='Sıc. Sensör 9' : null;
    kod=="tv748" ? metin='Sıc. Sensör 10' : null;
    kod=="tv749" ? metin='Sıc. Sensör 11' : null;
    kod=="tv750" ? metin='Sıc. Sensör 12' : null;
    kod=="tv751" ? metin='Sıc. Sensör 13' : null;
    kod=="tv752" ? metin='Sıc. Sensör 14' : null;
    kod=="tv753" ? metin='Sıc. Sensör 15' : null;
    kod=="tv754" ? metin='Kayıt Türü' : null;
    kod=="tv755" ? metin='Log Periyot' : null;
    kod=="tv756" ? metin='Tarih-İlk' : null;
    kod=="tv757" ? metin='Tarih-Son' : null;
    kod=="tv758" ? metin='Dk' : null;
    kod=="tv759" ? metin='Seçilen Tarih' : null;
    kod=="tv760" ? metin='KAYIT NO' : null;
    kod=="tv761" ? metin='SAAT' : null;
    kod=="tv762" ? metin='TARİH' : null;
    kod=="tv763" ? metin='DEĞER' : null;
    kod=="tv764" ? metin='En Yüksek' : null;
    kod=="tv765" ? metin='En Düşük' : null;
    kod=="tv766" ? metin='PARAMETRE' : null;
    kod=="tv767" ? metin='Alarm' : null;
    kod=="tv768" ? metin='Uyarı' : null;
    kod=="tv769" ? metin='ESKİ DEĞER' : null;
    kod=="tv770" ? metin='Elektrik-Günlük Toplam' : null;
    kod=="tv771" ? metin='Elektrik-Günlük Hayv. Baş.' : null;
    kod=="tv772" ? metin='Yem-Günlük Toplam' : null;
    kod=="tv773" ? metin='Yem-Günlük Hayv. Baş.' : null;
    kod=="tv774" ? metin='Su-Günlük Toplam' : null;
    kod=="tv775" ? metin='Su-Günlük Hayv. Baş.' : null;
    kod=="tv776" ? metin='HAYVAN SAYISI' : null;
    kod=="tv777" ? metin='KWsa' : null;
    kod=="tv778" ? metin='Lt' : null;
    kod=="tv779" ? metin='Toplam' : null;
    kod=="tv780" ? metin='Gr' : null;
    kod=="tv781" ? metin='mL' : null;
    kod=="tv782" ? metin='Ortalama' : null;
    kod=="tv783" ? metin='YENİ DEĞER' : null;
    kod=="tv784" ? metin='KULLANICI' : null;
    kod=="tv785" ? metin='NO' : null;
    kod=="tv786" ? metin='Klepe Uzunlukları' : null;
    kod=="tv787" ? metin='Bina Ölçüleri' : null;
    kod=="tv788" ? metin='Debi ve Nem' : null;
    kod=="tv789" ? metin='Fan Harita Resetleme' : null;
    kod=="tv790" ? metin='Klepe Harita Resetleme' : null;
    kod=="tv791" ? metin='Ped Harita Resetleme' : null;
    kod=="tv792" ? metin='Isı Sensor Harita Resetleme' : null;
    kod=="tv793" ? metin='Bacafan Harita Resetleme' : null;
    kod=="tv794" ? metin='Isıtıcı Harita Resetleme' : null;
    kod=="tv795" ? metin='Silo Harita Resetleme' : null;
    kod=="tv796" ? metin='Kalibrasyon\nDurdur' : null;
    kod=="tv796a" ? metin='Kalibrasyon Durdur' : null;
    kod=="tv797" ? metin='A.Inlet Motor KW' : null;
    kod=="tv798" ? metin='Isıtıcı KW' : null;
    kod=="tv799" ? metin='Sirk.Fanlar KW' : null;
    kod=="tv800" ? metin='Aydınlatma KW' : null;
    kod=="tv801" ? metin='STRES & KONFOR\nGRAFİĞİ' : null;
    kod=="tv801a" ? metin='STRES & KONFOR GRAFİĞİ' : null;
    kod=="tv802" ? metin='Normal' : null;
    kod=="tv803" ? metin='1. Uyarı' : null;
    kod=="tv804" ? metin='2. Uyarı' : null;
    kod=="tv805" ? metin='Teklike' : null;
    kod=="tv806" ? metin='Acil' : null;
    kod=="tv807" ? metin='SICAKLIK & NEM\nGRAFİĞİ' : null;
    kod=="tv807a" ? metin='SICAKLIK & NEM GRAFİĞİ' : null;
    kod=="tv808" ? metin='ORT.SIC.' : null;
    kod=="tv809" ? metin='IC NEM' : null;
    kod=="tv810" ? metin='DIŞ NEM' : null;
    kod=="tv811" ? metin='HİS .SIC. & NEM\nGRAFİĞİ' : null;
    kod=="tv811a" ? metin='HİS .SIC. & NEM GRAFİĞİ' : null;
    kod=="tv812" ? metin='Ort. Hissed. Sıc.' : null;
    kod=="tv812a" ? metin='Ort. Hissed.\nSıcaklık' : null;
    kod=="tv813" ? metin='HİS.SIC.' : null;
    kod=="tv814" ? metin='Sıcaklık' : null;
    kod=="tv815" ? metin='GÜNLÜK SIC. & SU\nTÜKETİM GRAFİĞİ' : null;
    kod=="tv815a" ? metin='GÜNLÜK SIC. & SU TÜKETİM GRAFİĞİ' : null;
    kod=="tv816" ? metin='AYLIK ELEKTRİK\nTÜKETİM GRAFİĞİ' : null;
    kod=="tv816a" ? metin='AYLIK ELEKTRİK TÜKETİM GRAFİĞİ' : null;
    kod=="tv817" ? metin='AYLIK SU\nTÜKETİM GRAFİĞİ' : null;
    kod=="tv817a" ? metin='AYLIK SU TÜKETİM GRAFİĞİ' : null;
    kod=="tv818" ? metin='AYLIK YEM\nTÜKETİM GRAFİĞİ' : null;
    kod=="tv818a" ? metin='AYLIK YEM TÜKETİM GRAFİĞİ' : null;
    kod=="tv819" ? metin='SU TÜK.' : null;
    kod=="tv820" ? metin='TOPLAM' : null;
    kod=="tv821" ? metin='HAY BAŞ.' : null;
    kod=="tv822" ? metin='(gün.ay)' : null;
   

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
    kod=="btn11" ? metin='Otomatik Ata' : null;
    kod=="btn12" ? metin='START' : null;
    kod=="btn13" ? metin='STOP' : null;
    kod=="btn14" ? metin='EKLE' : null;
    kod=="btn15" ? metin='GETİR' : null;
    kod=="btn16" ? metin='AKTİF' : null;
    kod=="btn17" ? metin='PASİF' : null;
    
    //endregion

    //region TEXTFIELD

    kod=="tflb1" ? metin='Tun. Fan Debi' : null;
    kod=="tflb2" ? metin='Baca Fan Debi' : null;
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


    //region ALARM VE UYARI LİSTESİ

    kod=="alarm1" ? metin='Acil Stop\'a basıldı!' : null;
    kod=="alarm2" ? metin='Faz sırası hatası!' : null;
    kod=="alarm3" ? metin='Elektrik kesildi veya ana sigorta attı!' : null;
    kod=="alarm4" ? metin='Tünel fanlarından birinin sigortası attı!' : null;
    kod=="alarm5" ? metin='Klepe motorlarından birinin sigortası attı!' : null;
    kod=="alarm6" ? metin='Ped motorlarından birinin sigortası attı!' : null;
    kod=="alarm7" ? metin='Air inlet motorlarından birinin sigortası attı!' : null;
    kod=="alarm8" ? metin='Baca fanlarından birinin sigortası attı!' : null;
    kod=="alarm9" ? metin='Isıtıcılardan birinin sigortası attı!' : null;
    kod=="alarm10" ? metin='Sirk. fanlarından birinin sigortası attı!' : null;
    kod=="alarm11" ? metin='Tünellerden birine su gitmiyor!' : null;
    kod=="alarm12" ? metin='Minimum sıcaklık!' : null;
    kod=="alarm13" ? metin='Maksimum sıcaklık!' : null;
    kod=="alarm14" ? metin='Minimum nem!' : null;
    kod=="alarm15" ? metin='Maksimum nem!' : null;
    kod=="alarm16" ? metin='Sıcaklık sensör 1 arızalı!' : null;
    kod=="alarm17" ? metin='Sıcaklık sensör 2 arızalı!' : null;
    kod=="alarm18" ? metin='Sıcaklık sensör 3 arızalı!' : null;
    kod=="alarm19" ? metin='Sıcaklık sensör 4 arızalı!' : null;
    kod=="alarm20" ? metin='Sıcaklık sensör 5 arızalı!' : null;
    kod=="alarm21" ? metin='Sıcaklık sensör 6 arızalı!' : null;
    kod=="alarm22" ? metin='Sıcaklık sensör 7 arızalı!' : null;
    kod=="alarm23" ? metin='Sıcaklık sensör 8 arızalı!' : null;
    kod=="alarm24" ? metin='Sıcaklık sensör 9 arızalı!' : null;
    kod=="alarm25" ? metin='Sıcaklık sensör 10 arızalı!' : null;
    kod=="alarm26" ? metin='Sıcaklık sensör 11 arızalı!' : null;
    kod=="alarm27" ? metin='Sıcaklık sensör 12 arızalı!' : null;
    kod=="alarm28" ? metin='Sıcaklık sensör 13 arızalı!' : null;
    kod=="alarm29" ? metin='Sıcaklık sensör 14 arızalı!' : null;
    kod=="alarm30" ? metin='Sıcaklık sensör 15 arızalı!' : null;
    kod=="alarm31" ? metin='İç ortam nem sensörü arızalı!' : null;
    kod=="alarm32" ? metin='Harici alarm aktif!' : null;
    kod=="alarm33" ? metin='Sayac 1 için su tüketimi minimumun altında kaldı!' : null;
    kod=="alarm34" ? metin='Sayac 2 için su tüketimi minimumun altında kaldı!' : null;
    kod=="alarm35" ? metin='Sayac 3 için su tüketimi minimumun altında kaldı!' : null;
    kod=="alarm36" ? metin='Sayac 4 için su tüketimi minimumun altında kaldı!' : null;
    kod=="alarm37" ? metin='Sayac 5 için su tüketimi minimumun altında kaldı!' : null;
    kod=="alarm38" ? metin='Sayac 6 için su tüketimi minimumun altında kaldı!' : null;
    kod=="alarm39" ? metin='Sayac 7 için su tüketimi minimumun altında kaldı!' : null;
    kod=="alarm40" ? metin='Sayac 8 için su tüketimi minimumun altında kaldı!' : null;
    kod=="alarm41" ? metin='Sayac 9 için su tüketimi minimumun altında kaldı!' : null;
    kod=="alarm42" ? metin='Sayac 10 için su tüketimi minimumun altında kaldı!' : null;
    kod=="alarm43" ? metin='Sayac 11 için su tüketimi minimumun altında kaldı!' : null;
    kod=="alarm44" ? metin='Sayac 12 için su tüketimi minimumun altında kaldı!' : null;
    kod=="alarm45" ? metin='Kümes içi yüksek sıcaklık! (Harici güvenlik sensörü)' : null;
    kod=="alarm46" ? metin='Pano içi yüksek sıcaklık!' : null;


    kod=="korna1" ? metin='Acil\nStop' : null;
    kod=="korna2" ? metin='Faz\nHatası' : null;
    kod=="korna3" ? metin='Elektrik Kesildi' : null;
    kod=="korna4" ? metin='T. Fan Termik' : null;
    kod=="korna5" ? metin='Klepe Termik' : null;
    kod=="korna6" ? metin='Ped Termik' : null;
    kod=="korna7" ? metin='A.Inlet Termik' : null;
    kod=="korna8" ? metin='B.Fan Termik' : null;
    kod=="korna9" ? metin='Isıtıcı Termik' : null;
    kod=="korna10" ? metin='Sirk. Fan Termik' : null;
    kod=="korna11" ? metin='Tünel Su Gitmiyor' : null;
    kod=="korna12" ? metin='Minimum Sıcaklık' : null;
    kod=="korna13" ? metin='Maksimum Sıcaklık' : null;
    kod=="korna14" ? metin='Minimum Nem' : null;
    kod=="korna15" ? metin='Maksimum Nem!' : null;
    kod=="korna16" ? metin='Sıc. Sens. 1 Arıza' : null;
    kod=="korna17" ? metin='Sıc. Sens. 2 Arıza' : null;
    kod=="korna18" ? metin='Sıc. Sens. 3 Arıza' : null;
    kod=="korna19" ? metin='Sıc. Sens. 4 Arıza' : null;
    kod=="korna20" ? metin='Sıc. Sens. 5 Arıza' : null;
    kod=="korna21" ? metin='Sıc. Sens. 6 Arıza' : null;
    kod=="korna22" ? metin='Sıc. Sens. 7 Arıza' : null;
    kod=="korna23" ? metin='Sıc. Sens. 8 Arıza' : null;
    kod=="korna24" ? metin='Sıc. Sens. 9 Arıza' : null;
    kod=="korna25" ? metin='Sıc. Sens. 10 Arıza' : null;
    kod=="korna26" ? metin='Sıc. Sens. 11 Arıza' : null;
    kod=="korna27" ? metin='Sıc. Sens. 12 Arıza' : null;
    kod=="korna28" ? metin='Sıc. Sens. 13 Arıza' : null;
    kod=="korna29" ? metin='Sıc. Sens. 14 Arıza' : null;
    kod=="korna30" ? metin='Sıc. Sens. 15 Arıza' : null;
    kod=="korna31" ? metin='Nem Sens. Arıza!' : null;
    kod=="korna32" ? metin='Harici Alarm' : null;
    kod=="korna33" ? metin='Sayac 1 Min. Tük.' : null;
    kod=="korna34" ? metin='Sayac 2 Min. Tük.' : null;
    kod=="korna35" ? metin='Sayac 3 Min. Tük.' : null;
    kod=="korna36" ? metin='Sayac 4 Min. Tük.' : null;
    kod=="korna37" ? metin='Sayac 5 Min. Tük.' : null;
    kod=="korna38" ? metin='Sayac 6 Min. Tük.' : null;
    kod=="korna39" ? metin='Sayac 7 Min. Tük.' : null;
    kod=="korna40" ? metin='Sayac 8 Min. Tük.' : null;
    kod=="korna41" ? metin='Sayac 9 Min. Tük.' : null;
    kod=="korna42" ? metin='Sayac 10 Min. Tük.' : null;
    kod=="korna43" ? metin='Sayac 11 Min. Tük.' : null;
    kod=="korna44" ? metin='Sayac 12 Min. Tük.' : null;
    kod=="korna45" ? metin='Harici Yük. Sic.' : null;
    kod=="korna46" ? metin='Pano İçi Yük. Sic.' : null;


    kod=="uyari61" ? metin='Dış ortam nem sensörü arızalı!' : null;
    kod=="uyari62" ? metin='Dış ortam sıcaklık sensörü arızalı!' : null;
    kod=="uyari63" ? metin='Ped bakım zamanı geldi!' : null;
    kod=="uyari64" ? metin='Sistem bakım zamanı geldi!' : null;
    
    //endregion






    //region TOAST

    kod=="toast1" ? metin='Lütfen en az 4 karakterlik bir kümes ismi belirleyiniz!' : null;
    kod=="toast2" ? metin='Lütfen 4 basamaklı bir sifre belirleyiniz!' : null;
    kod=="toast3" ? metin='Şifreler uyuşmuyor!' : null;
    kod=="toast4" ? metin='Fan kontrol yöntemlerinden en az biri seçilmiş olmalıdır!' : null;
    kod=="toast5" ? metin='Tanımlanan klepe sayısından büyük sayı girdiniz. Lütfen kontrol ediniz!' : null;
    kod=="toast6" ? metin='Klepe No , X(m) veya Y(m) değerinden biri veya birkaçı boş' : null;
    kod=="toast7" ? metin='KlepeNo, X(m) veya Y(m) değerlerinden birine geçersiz bir girişi yapıldı' : null;
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
    kod=="toast24" ? metin='Lütfen seçili tüm fanlar için sıfırdan farklı Fan No tanımlayınız!' : null;
    kod=="toast25" ? metin='Aynı Fan No iki farklı fan için tanımlanmış! Lütfen kontrol ediniz' : null;
    kod=="toast26" ? metin='Bir Çıkış iki farklı unsur için tanımlanmış! Lütfen kontrol ediniz' : null;
    kod=="toast27" ? metin='Lütfen önce tanımladığınız verileri gönderiniz!' : null;
    kod=="toast28" ? metin='Aynı Klepe No iki farklı klepe için tanımlanmış! Lütfen kontrol ediniz' : null;
    kod=="toast29" ? metin='Haritada seçilen klepe sayısı, tanımlanandan eksik!' : null;
    kod=="toast30" ? metin='Haritada seçilen klepe sayısı, tanımlanandan fazla!' : null;
    kod=="toast31" ? metin='Aynı Isı Sensör No iki farklı Isı Sensör için tanımlanmış! Lütfen kontrol ediniz' : null;
    kod=="toast32" ? metin='Aynı Ped No iki farklı ped için tanımlanmış! Lütfen kontrol ediniz' : null;
    kod=="toast33" ? metin='Aktif sensörlerden ikisine aynı numara atanmış! Lütfen kontrol ediniz' : null;
    kod=="toast34" ? metin='En az bir tane aktif sensor atanmış olmalıdır' : null;
    kod=="toast35" ? metin='Lütfen seçili tüm ısı sensörler için sıfırdan farklı sensör no tanımlayınız!' : null;
    kod=="toast36" ? metin='Lütfen seçili tüm pedler için sıfırdan farklı Ped No tanımlayınız!' : null;
    kod=="toast37" ? metin='Lütfen seçili tüm klepeler için sıfırdan farklı Klepe No tanımlayınız!' : null;
    kod=="toast38" ? metin='Atanacak çıkışlardan biri şu anda kullanımda! Lütfen önce ilgili çıkışı boşa çıkarın' : null;
    kod=="toast39" ? metin='Lütfen harita üzerinde seçili tüm bacafanları için sıfırdan farklı no tanımlayınız!' : null;
    kod=="toast40" ? metin='Lütfen toplam sensör sayısına eşit veya daha küçük bir sayı tanımlayınız!' : null;
    kod=="toast41" ? metin='Seçilen sensör numarası harita üzerinde tanımlı değil!' : null;
    kod=="toast42" ? metin='Aynı Air Inlet No iki farklı air inlet için tanımlanmış! Lütfen kontrol ediniz!' : null;
    kod=="toast43" ? metin='Görev komutu göndermede komut alanı boş!' : null;
    kod=="toast44" ? metin='Lütfen toplam air inlet motor sayısına eşit veya daha küçük bir no tanımlayınız! ' : null;
    kod=="toast45" ? metin='Lütfen toplam ped motor sayısına eşit veya daha küçük bir no tanımlayınız! ' : null;
    kod=="toast46" ? metin='Lütfen toplam klepe motor sayısına eşit veya daha küçük bir no tanımlayınız! ' : null;
    kod=="toast47" ? metin='Lütfen toplam fan sayısına eşit veya daha küçük bir no tanımlayınız! ' : null;
    kod=="toast48" ? metin='En az bir tane ısıtıcı haritada işaretlenmiş olmalıdır!' : null;
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
    kod=="toast60" ? metin='Sensör için wifi bağlantı seçildi.' : null;
    kod=="toast61" ? metin='Sensör için Analog bağlantı seçildi.' : null;
    kod=="toast62" ? metin='Önce haritayı oluşturup onaylamanız gerekli!' : null;
    kod=="toast63" ? metin='Lütfen sıfırdan farklı bir Çıkış No tanımlayınız!' : null;
    kod=="toast64" ? metin='Kurulum başarıyla tamamlandı...' : null;
    kod=="toast65" ? metin='Civciv ve Broyler kafeslerinde aktif değildir.' : null;
    kod=="toast66" ? metin='Baca fanı olmayan Civciv veya Broyler kafeslerinde PID kontrol aktif değildir.' : null;
    kod=="toast67" ? metin='Sadece bacafanı olmayan Tavuk kafesleri için aktiftir.' : null;
    kod=="toast68" ? metin='Şu anda zaten ilgili klepe için kalibrasyon devam ediyor.' : null;
    kod=="toast69" ? metin='Klepe kalibrasyon sadece ilgili klepe otomatik modda ise aktiftir.' : null;
    kod=="toast70" ? metin='Kalibrasyon başladı...' : null;
    kod=="toast71" ? metin='Kalibrasyon sonlandırıldı...' : null;
    kod=="toast72" ? metin='Bu parametre "Fasıla Döngü Süresi" 10 dk olarak seçiliyse aktif edilebilir' : null;
    kod=="toast73" ? metin='Lütfen sıfırdan farklı bir Grup No tanımlayınız!' : null;
    kod=="toast74" ? metin='Lütfen önce "Ac-Kapa Saati 2 Aktif" seçeneğini işaretleyin!' : null;
    kod=="toast75" ? metin='Dimmer aktifken devre dışıdır!' : null;
    kod=="toast76" ? metin='Lütfen tüm girişler için atama yapınız!' : null;
    kod=="toast77" ? metin='Geçersiz tarih hatası! Lütfen geçmiş bir tarih giriniz...' : null;
    kod=="toast78" ? metin='Şu anda Klepe kapama işlemi yapıyor, açma işlemi devre dışıdır! ' : null;
    kod=="toast79" ? metin='Şu anda Klepe açma işlemi yapıyor, kapama işlemi devre dışıdır! ' : null;
    kod=="toast80" ? metin='Şu anda Air Inlet kapama işlemi yapıyor, açma işlemi devre dışıdır! ' : null;
    kod=="toast81" ? metin='Şu anda Air Inlet açma işlemi yapıyor, kapama işlemi devre dışıdır! ' : null;
    kod=="toast82" ? metin='Şu anda tanımlı bir dış nem sensörü olmadığı için devre dışıdır! ' : null;
    kod=="toast83" ? metin='Bu numarada tanımlı bir sensor yok! ' : null;
    kod=="toast84" ? metin='Bu numara dış sıcaklık sensörü için tanımlanmış, Lütfen farklı bir numara seçin! ' : null;
    kod=="toast85" ? metin='Yem çıkış 1 kurulum ayarlarında tanımlanmamış! Lütfen kontrol edin.' : null;
    kod=="toast86" ? metin='Yem çıkış 2 kurulum ayarlarında tanımlanmamış! Lütfen kontrol edin.' : null;
    kod=="toast87" ? metin='Yem çıkış 3 kurulum ayarlarında tanımlanmamış! Lütfen kontrol edin.' : null;
    kod=="toast88" ? metin='1500sn\'den (25dk) büyük değer giremezsiniz!' : null;
    kod=="toast89" ? metin='Tarih formatı AM/PM için hatalı saat girişi yaptınız!' : null;
    kod=="toast90" ? metin='Lütfen sıfırdan farklı bir Isıtıcı Grup Çıkış No tanımlayınız!' : null;
    kod=="toast91" ? metin='Bağlantı zaman aşımına uğradı!' : null;
    kod=="toast92" ? metin='Geçersiz bir Çıkış seçtiniz! Lütfen "ÇIKIŞLAR" alanında listelenenlerden birini seçiniz' : null;
    kod=="toast93" ? metin='Geçersiz bir giriş seçtiniz! Lütfen "GiRİŞLER" alanında listelenenlerden birini seçiniz' : null;
    kod=="toast94" ? metin='Seçilen giriş başka bir unsur tarafından kullanılıyor! Lütfen farklı bir giriş seçiniz' : null;
    kod=="toast95" ? metin='Tüm girişler otomatik olarak sırayla atandı' : null;
    kod=="toast96" ? metin='Aynı Bacafan No iki farklı bacafan için tanımlanmış! Lütfen kontrol ediniz' : null;
    kod=="toast97" ? metin='Tanımlanmamış çıkış var! Lütfen aktif tüm çıkışlar için atama yapınız' : null;
    kod=="toast98" ? metin='Hata hala aktif, o yüzden resetlenemez!' : null;
    kod=="toast99" ? metin='Alarm hala aktif, o yüzden resetlenemez!' : null;
    kod=="toast100" ? metin='Alarm metni için en az 10 karakter giriniz!' : null;
    kod=="toast101" ? metin='Yazdırma hatası! Yazdırma portu kapalı.Ağ hatası yoksa Server PC\'yi yeniden başlatınız.' : null;
    kod=="toast102" ? metin='Girilen ayda herhangi bir log kaydı bulunmamaktadır.' : null;
    kod=="toast103" ? metin='Girilen gün aralığında herhangi bir log kaydı bulunmamaktadır.' : null;
    kod=="toast104" ? metin='Tarih İlk ve Tarih Son parametrelerine aynı ay ve yıl girilmelidir!' : null;
    


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
    ' baca fanlarıyla birlikte, (D) bölgesinde ise tek başına devrede olmuş olur.\n\n'
    ' Min. Hav. Durduğunda Debi Korunsun mu?:\n'
    ' Minimum havalandırma fanlarının durup, sadece tünel havalandırma fanlarının çalıştığı moda geçilirken debi kaybı olmasın diye çalışan tünel fan sayısını'
    ' kapanan min. hav. fanlarının debisi kadar artırır.Bir diğer deyişle tünel havalandırma modunda minimum çalışan minimum tünel fan sayısını, min. hav. fanlarının toplam'
    ' debisini sağlayacak sayıda ayarlar.\n\n\n' : null;


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
    ' sıcaklık arttıkça artış miktarında tanımlanan adet kadar fan devreye girer ve (A+B+C+H) sıcaklığında tüm fanlar devrede olur.\n\n'
    ' Min. Hav. Durduğunda Debi Korunsun mu?:\n'
    ' Minimum havalandırma fanlarının durup, sadece tünel havalandırma fanlarının çalıştığı moda geçilirken debi kaybı olmasın diye çalışan tünel fan sayısını'
    ' kapanan min. hav. fanlarının debisi kadar artırır.Bir diğer deyişle tünel havalandırma modunda minimum çalışan minimum tünel fan sayısını, min. hav. fanlarının toplam'
    ' debisini sağlayacak sayıda ayarlar.\n\n\n' : null;






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
    kod=="info10" ? metin=' Ortalama sıcaklık değeri ilgili ped pompasının "Çalışma Sıcaklığı(A+X+B)" değerine yükseldiğinde ped pompası çalışmaya başlar. Ortalama sıcaklık değeri'
    ' ilgili ped pompasının "Durma Sıcaklığı(A+X+C)" değerine düşünceye kadar ped pompası çalışmaya devam eder.\n\n'
    ' Kümes içi nem değeri girilen "Maximum Nem(D)" değerine ulaştığı zaman sistem "Yüksek Nem Aktif" durumuna geçer ve hiçbir ped pompasının çalışmasına izin vermez.'
    ' İç nem değeri "Maximum Nem" değerinin "Nem Fark(E)" kadar altına düştüğünde "Yüksek Nem Pasif" durumuna geçer ve ped pompalarının çalışmasına izin verir.\n\n'
    ' Kümes içi nem değeri girilen "Minimum Nem" değerinin altına düştüğünde eğer "Düşük Nemde Ped Çalışsın" opsiyonu aktifse seçiminize göre ped 1 veya'
    ' ped 2-3 veya her 3 pompayı birden devreye sokar. Kümes içi nem değeri "Minimum Nem" değerinin "Nem Fark" kadar üstüne çıktığında seçili ped pompalarını durdurur.'
    ' Eğer "Sıcaklık Öncelikli" opsiyonunu aktif ederseniz ve ortalama sıcaklık set sıcaklığının altında olursa ped pompaları düşük nem şartları sağlansa bile devreye girmez.'
    ' Çalışma prensibini gösterir diyagram Yüksek Nem durumunu anlatan diyagram ile aynıdır.\n\n' 
    ' Ped pompaları ortalama sıcaklığa göre çalışma durumuna geçtiğinde çalışmayı fasılalı olarak yapar. "Çalışma Sür.(Sn)" kadar çalışır, "Durma Sür.(Sn)" kadar bekler.' : null;


    //Isıtma ayarları
    kod=="info11" ? metin=' Kümes içi ortalama sıcaklık değeri ilgili ısıtıcı grubu için girilen \"Çalışma Sıcaklığı(A-B)\" değerine düştüğünde ısıtıcı grubu start alır. '
    'Ortalama sıcaklık ilgili ısıtıcı grubunun \"Durma Sıcaklığı(A-C)\" değerine yükseldiğinde ısıtıcı grubu stop duruma geçer.' : null;


    //MH Ağırlık-Dijital Çıkış
    kod=="info12_1" ? metin='   Minimum Havalandırma Ağırlık Modu\'nda sistem hayvanların ağırlıklarına göre saatlik temiz hava ihtiyaçları üzerinden gerekli hesaplamaları yapar ve'
    ' minimum havalandırma için belirlenen fanlar buna göre kontrol edilir. Minimum havalandırma fanları set değerinin üzerinde bulunan doğal bölgede ve çapraz havalandırma'
    ' bölgesinde sürekli, set değerinin altında fasılalı olarak çalışır.\n'
    '     Sistem sürü yaşına göre hayvan başına düşen minimum hava ihtiyacını "SÜRÜ BİLGİLERİ" sayfasındaki "Hayvan Başına Min. Hav. İhtiyacı(m3/h)" alanına girilen verilere göre'
    ' tespit eder ve bu bilgi üzerinden tüm sürü için 5dk\'daki veya 10dk\'daki toplam hava ihtiyacını hesaplar.'
    ' Hesaplanan bu hava ihtiyacını karşılamak için 5dk\'nın veya 10dk\'nın bir kısmında durma, bir kısmında çalışma şeklinde fasıla yaparak Min. Hav. fanlarını çalıştırır '
    ' Baca fanı varsa baca fanlarının toplam debisini hesaba katarak fasıla sürelerini hesaplar. Eğer baca fanı yok da tünel fanlarından birkaçı Min. Hav. için'
    ' kullanılacaksa kaç tane tünel fanının çalışacağını ve ne kadar fasıla yapacağını hesaplanan hava ihtiyacına göre sistem belirler\n\n'  : null;

    //MH Ağırlık-Analog Çıkış
    kod=="info12_2" ? metin='   Minimum Havalandırma Ağırlık Modu\'nda sistem hayvanların ağırlıklarına göre saatlik temiz hava ihtiyaçları üzerinden gerekli hesaplamaları yapar ve'
    ' minimum havalandırma için belirlenen fanlar buna göre kontrol edilir. Minimum havalandırma fanları set değerinin üzerinde bulunan doğal bölgede ve çapraz havalandırma'
    ' bölgesinde maksimum hız olan 50Hz\'de ve sürekli, set değerinin altında hesaplanan hızda ve yine sürekli olarak çalışır.\n'
    '     Sistem sürü yaşına göre hayvan başına düşen minimum hava ihtiyacını "SÜRÜ BİLGİLERİ" sayfasındaki "Hayvan Başına Min. Hav. İhtiyacı(m3/h)" alanına girilen verilere göre'
    ' tespit eder ve bu bilgi üzerinden tüm sürü için gerekli hava miktarını içeri alacak şekilde bacafan motorlarının hızlarını sürücü üzerinden ayarlar.'
    ' Sistem bacafanlarını ayarladığı hızda sürekli olarak çalıştırır\n\n'  : null;


    //MH Ağırlık-Fasılada Maximum Çalışma Yüzdesi
    kod=="info12_3" ? metin='     Fasılada Max. Çalışma Yüzdesi:\n'
    'Min. Hav. fanları fasıla yaparken toplam döngü süresinin en fazla % kaçı kadarında çalışır pozisyonda kalabileceğinin belirlendiği parametredir. '
    ' Örneğin döngü süresi 5 dk yani 300sn seçilmişse ve bu parametreye de %70 girilmişse fanların fasıla yaparken çalışma süresi en fazla 210 Sn olabilir. '
    ' Eğer 1 fan ile hava ihtiyacını karşılamak için sistem bu parametreye girilen değerden daha yüksek bir süre hesaplarsa fan sayısını bir artırarak çalışma'
    ' süresini bu parametredeki değerin altına düşürmeye çalışır.\n\n'  : null;


    //MH Ağırlık-Air inlet Öncelik Süresi
    kod=="info12_4" ? metin='     Air Inlet Öncelik Süresi:\n'
    'Fasıla sırasında Min. Hav. fanları devreye girmeden kaç sn önce Air Inlet\'lerin açılmaya başlamasını belirleyen parametredir. Bu sayede bacafanları'
    ' çalıştığında air inletler açık olacağından kümes içinde oluşacak vakum etkisi önlenmiş olur.\n\n'  : null;


    //MH Ağırlık-Hava giriş yüzdesi
    kod=="info12_5" ? metin='     Hava Giriş Yüzdesi:\n'
    'Hesaplanan toplam hava ihtiyacının % kaçının Min. Hav. fanlarıyla karşılanacağını belirleyen parametredir.\n\n'  : null;


    //MH Ağırlık-Fasıla durma da air inlet kapansın mı?
    kod=="info12_6" ? metin='     Fasıla Durma\'da Air Inlet Kapansın mı?:\n'
    'Bu parametre aktifleştirildiğinde sistem fasılanın durma pozisyonunda air inletleri kapatır. Eğer air inletlerin tam açık pozisyondan tam kapalı pozisyona gelme'
    ' süresi Fasıla Durma süresinden büyük olduğunda bu özellik devre dışıdır.\n\n'  : null;


    //MH Ağırlık-Fasıla döngü süresi
    kod=="info12_7" ? metin='     Fasıla Döngü Süresi:\n'
    'Minimum havalandırma fasıla modundayken fasıla döngüsünü bu parametreye göre yapar. Seçili sürenin hesaplanan bir kısmında Min. Hav fanları çalışır, kalan kısmında'
    ' Min. Hav fanları durur.\n\n'  : null;


    //MH Ağırlık-Sadece Min. Hav. Modu Aktif
    kod=="info12_8" ? metin='     Sadece Min. Hav. Modu Aktif:\n'
    'Hayvanların belirli bir yaşa gelene kadar kümesin sadece Minimum Havalandırma modu ile havalandırılması isteniyorsa bu seçenek aktif edilmelidir. Aktif edildiğinde'
    ' günlük bazda kaç günlük oluncaya kadar sadece Min. Hav. yapılmasını belirleyeceğiniz bir seçenek görünür olacaktır.\n\n'  : null;


     //MH Ağırlık-İlk Kaç Gün Sadece Min. Hav. Yapsın
    kod=="info12_9" ? metin='     İlk Kaç Gün Sadece Min. Hav. Yapsın:\n'
    'Hayvanların günlük bazda kaç yaşına gelinceye kadar sadece min. hav. aktif olsun durumunun belirlendiği parametredir. Örn. bu parametreye 10 değeri girilirse'
    ' sürü yaşı 11 olunca sistem sadece min. hav. yap modundan çıkarak normal işleyişine döner.\n\n'  : null;


    




    //MH Hacim-Dijital Çıkış
    kod=="info13_1" ? metin='   Minimum Havalandırma Hacim Modu\'nda sistem kurulum ayarlarından girilen bina ölçüleri ve hacim oranı değerlerine göre hesaplanan kümes içindeki'
    ' aktif hacim miktarı kadar havanın seçilen döngü süresinde kümes dışına atılması, dışarı atılan kirli hava kadar taze havanın da kümes içine alınmasını sağlar.'
    ' Minimum havalandırma fanları set değerinin üzerinde bulunan doğal bölgede ve çapraz havalandırma bölgesinde sürekli, set değerinin altında fasılalı olarak çalışır.\n'
    '     Hesaplanan aktif hacmin değişimi için 5dk\'nın veya 10dk\'nın bir kısmında durma, bir kısmında çalışma şeklinde fasıla yaparak Min. Hav. fanlarını çalıştırır '
    ' Baca fanı varsa baca fanlarının toplam debisini hesaba katarak fasıla sürelerini hesaplar. Eğer baca fanı yok da tünel fanlarından birkaçı Min. Hav. için'
    ' kullanılacaksa kaç tane tünel fanının çalışacağını ve ne kadar fasıla yapacağını hesaplanan aktif hacim miktarına göre sistem belirler\n\n'  : null;


    //MH Hacim-Analog Çıkış
    kod=="info13_2" ? metin='   Minimum Havalandırma Hacim Modu\'nda sistem kurulum ayarlarından girilen bina ölçüleri ve hacim oranı değerlerine göre hesaplanan kümes içindeki'
    ' aktif hacim miktarı kadar havanın seçilen döngü süresinde kümes dışına atılması, dışarı atılan kirli hava kadar taze havanın da kümes içine alınmasını sağlar.'
    ' Minimum havalandırma fanları set değerinin üzerinde bulunan doğal bölgede ve çapraz havalandırma bölgesinde maksimum hız olan 50Hz\'de ve sürekli, set değerinin'
    ' altında hesaplanan hızda ve yine sürekli olarak çalışır.\n'
    '     Sistem kümes içerisinde bulunan hava dolu aktif hacmi hesaplayarak bu bilgi üzerinden tüm sürü için gerekli hava miktarını içeri alacak şekilde bacafan motorlarının'
    ' hızlarını sürücü üzerinden ayarlar. Eğer döngü süresi 5dk seçilirse aktif hacmi 5dk\'da bir dışarı atacak şekilde bacafan motor hızlarını ayarlar, eğer 10 dk seçilirse'
    ' aynı şekilde aktif hacmi 10 dk\'da bir dışarı atacak şekilde bacafan motorlarının hızlarını ayarlar. Sistem bacafanlarını ayarladığı hızda sürekli olarak çalıştırır\n\n'  : null;


    //MH Ağırlık-Toplam aktif hacim kac dk da yenilensin - dijital çıkış
    kod=="info13_3" ? metin='     Toplam Aktif Hacim kaç dk\'da bir yenilensin?:\n'
    'Minimum havalandırma fasıla modundayken fasıla döngüsünü bu parametreye göre yapar. Seçili sürenin hesaplanan bir kısmında Min. Hav fanları çalışır, kalan kısmında'
    ' Min. Hav fanları durur. Eğer x2 seçeneği aktif edilirse aktif hacmi 5 dk\'da bir değiştirmek üzere çalışma ve durma süresini hesaplar sadece çalışma ve durma'
    ' sürelerini 2 ile çarparak çalışma ve durma sürelerinin toplamını 10 dk olarak ayarlar. \n\n'  : null;

    //MH Ağırlık-Toplam aktif hacim kac dk da yenilensin? - analog çıkış
    kod=="info13_4" ? metin='     Toplam Aktif Hacim kaç dk\'da bir yenilensin?:\n'
    'Ortalama sıcaklık set değerinin altındayken bacafan motorlarının hızlarını bu parametrede seçilen süreye göre ayarlar. Eğer 5dk seçilirse aktif hacmi 5dk\'da bir'
    ' değiştirecek şekilde motor hızlarını ayarlar, 10dk seçilirse aynı şekilde aktif hacmi 10 dk\'da bir değiştirecek şekilde motor hızlarını ayarlar.\n\n'  : null;



    //MH Ek bilgi 1
    kod=="info14_1" ? metin='     Eğer kümes içerisinde belirli seviyede yüksek nem varsa "Hava Giriş Yüzdesi(%)" parametre değeri, %5 artırılmalıdır.'
    ' Kümes içerisinde amonyak yüksekse "Hava Giriş Yüzdesi(%)" parametre değeri %5 veya %10 artırılmalıdır. Eğer kümes içerisinde toz var ise bu sefer'
    ' "Hava Giriş Yüzdesi(%)" parametre değeri %5 azaltılmalıdır.\n\n'  : null;

    //MH Ek bilgi 2
    kod=="info14_2" ? metin='     Eğer kümes içerisinde belirli seviyede yüksek nem varsa "Çalışma Süresi" parametre değerleri, %5 artırılmalıdır.'
    ' Kümes içerisinde amonyak yüksekse "Çalışma Süresi" parametre değerleri %5 veya %10 artırılmalıdır. Eğer kümes içerisinde toz var ise bu sefer'
    ' "Çalışma Süresi" parametre değerleri %5 azaltılmalıdır.\n\n'  : null;

    //Klepe Prob Kontrol - YRD Opsiyonlar - Opsiyon 2
    kod=="info15" ? metin='     Klepe açıklıklarının KONTROL→KLEPE sayfasında belirtilen parametrelere göre açılıp kapanmasına ek olarak bu sayfadaki'
    ' SENSOR KLEPE KONTROL seçeneği ilgili klepe için aktif hale getirilirse klepe açıklıklarına etki ederler. Bu opsiyonun aktif hale getirdiğimiz klepenin'
    ' açıklık oranına etkisi şu şekildedir:\n\n'
    ' Klepenin hangi ısı sensörüne veya sensörlerine göre çalışmasını istiyorsak, Sens. No1 ve Sens. No2 parametrelerine ilgili ısı sensörünün numarası girilir.'
    ' Eğer bir ısı sensörüne göre çalışacaksa Sens. No2\'ye 0 girilmelidir. İki sensör tanımlandıysa, bu sensörlerin ortalaması, bir sensör tanımladıksa tanımlanan'
    ' bu sensörün değeri set sıcaklığının(A) altına düştüğünde klepe açıklığı oransal olarak küçültülür. Seçilen sensör veya sensörlerin ortalaması set değerinden'
    ' sıcaklık farkı(X) kadar altına yani (A-X) değerine düşerken mevcut klepe açıklığı da (K) değerinden (K/2) değerine yani yarısına düşer.\n\n'
    ' Bu opsiyon aktif edilse dahi sadece sistem çapraz havalandırma veya tünel havalandırma modunda iken çalışır. Yani kümes içi tüm sensörlerin ortalaması'
    ' doğal bölge bitiş sıcaklığının üstündeyken aynı zamanda ilgili klepe için seçilen sensörlerin ortalaması da set değerinin altında olduğunda bu opsiyon'
    ' klepe açıklığına etki eder. \n\n'  : null;


    //Unsur OTO-MAN seçimi ve Manuel kontrol
    kod=="info16_1" ? metin='     Sistem içerisinde soğutma-havalandırma veya yemleme için kullanılan tüm unsurların OTOMATİK veya MANUEL moda alındığı'
    ' sayfadır. İlgili unsur OTOMATİK moda alındığında kontrol sayfasında tanımlanan parametrelere göre sistem kontrol unsuru çalıştırmaya başlar.'
    ' İlgili unsur MANUEL moda alındığında unsuru manuel kontrol etmemizi sağlayan diyalog penceresini açan resimli buton hemen OTO-MAN butonlarının altında'
    ' görünür olacaktır.Buraya tıklayarak ekranın altında beliren diyalog penceresinden unsuru manuel olarak kontrol edebilirsiniz.\n\n'
    ' KLEPE ve AIR INLET için de OTO-MAN butonuna tıklayarak ilgili sayfaya gidebilirsiniz. \n\n'  : null;

    //Klepe OTO-MAN seçimi ve Manuel kontrol
    kod=="info16_2" ? metin='     Sistem içerisinde kullanılan Klepelerin OTOMATİK veya MANUEL moda alındığı'
    ' sayfadır. İlgili klepe OTOMATİK moda alındığında KONTROL→KLEPE sayfasında tanımlanan parametrelere göre otomatik olarak sistem klepeyi çalıştırmaya başlar.'
    ' İlgili klepe MANUEL moda alındığında klepeyi manuel kontrol etmemizi sağlayan diyalog penceresini açan resimli buton hemen OTO-MAN butonlarının altında'
    ' görünür olacaktır.Buraya tıklayarak ekranın altında beliren diyalog penceresinden klepeye manuel olarak aç-kapa yaptırabilirsiniz. Açılan diyalog penceresinde'
    ' "Klepe Hareket Süresi (Sn)" parametresi sıfır olursa komut verdiğinizde siz durdurana kadar aç veya kapa yapmaya devam eder, bu parametreye bir süre girildiğinde'
    ' aç veya kapa komutu verirseniz klepeye girilen bu süre kadar aç veya kapa yaptırır ve sonra kendiliğinden durur.\n\n'  : null;

    //Air Inlet OTO-MAN seçimi ve Manuel kontrol
    kod=="info16_3" ? metin='     Sistemde içerisinde kullanılan Air Inlet\'lerin OTOMATİK veya MANUEL moda alındığı'
    ' sayfadır. İlgili Air Inlet OTOMATİK moda alındığında kontrol sayfasında tanımlanan parametrelere göre otomatik olarak sistem Air Inlet\'i çalıştırmaya başlar.'
    ' İlgili Air Inlet MANUEL moda alındığında Air Inlet\'i manuel kontrol etmemizi sağlayan diyalog penceresini açan resimli buton hemen OTO-MAN butonlarının altında'
    ' görünür olacaktır.Buraya tıklayarak ekranın altında beliren diyalog penceresinden Air Inlet\'i manuel olarak aç-kapa yaptırabilirsiniz. Açılan diyalog penceresinde'
    ' "Air Inlet Hareket Süresi (Sn)" parametresi sıfır olursa komut verdiğinizde siz durdurana kadar aç veya kapa yapmaya devam eder, bu parametreye bir süre girildiğinde'
    ' aç veya kapa komutu verirseniz sistem Air Inlet\'lere girilen bu süre kadar aç veya kapa yaptırır ve sonra kendiliğinden durur.\n\n'  : null;





    //MH Klasik (Bacafan ve air inlet olmayan Tavuk kümeslerinde kullanılır)
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
    ' Ortalama sıcaklık, Fasıla Set 3(E) değerinden küçük veya eşit olduğunda fanlar "Çalışma Süresi 4" kadar çalışır "Durma Süresi 4" kadar durur.\n\n'  : null;



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


    //Sürü Bilgileri
    kod=="info20" ? metin=' Bu bölümde kafese konulan hayvanlar ile ilgili bilgiler girilir. "Sürü Doğum Tarihi" alanına getirilen hayvanların yumurtadan çıkış tarihi'
    ' "Sürü Giriş Tarihi" alanına da hayvanların kafese konulduğu tarih girilmelidir. "Hayvan Sayısı (girişte)" alanına hayvanların kafese konulduğu ilk günkü adet'
    ' girilmelidir ki genelde bu toplam kafes kapasitesidir. "Ölü Hayvan Sayısı" alanında gösterilen değer toplam değerdir. Bu alana tıklandığınızda ölü sayısını'
    ' kategorilere uygun şekilde gireceğiniz bir pencere açılır. Meydana gelen ölümleri bu kategorilere göre girerek kafesle ilgili daha doğru analiz yapacak veriler'
    ' oluşturabilirsiniz.\n\n'  : null;

    kod=="info20a" ? metin='İlk gün kafese konulan toplam hayvan sayısının bu güne kadar yüzde kaçının öldüğünü gösterir.\n\n'  : null;

    kod=="info20b" ? metin='Ölü hayvan sayısı çıkarılarak an itibariyle kafeste kaç hayvan olduğunu gösterir.\n\n'  : null;

    kod=="info20c" ? metin='Sürünün bu alanda belirtilen her dönem için ağırlığına göre ihtiyaç duyduğu m3/h bazında hava ihtiyacı bilgisi katalogtan elde edilerek'
    ' bu alana girilir. Böylece sistem sürü yaşına göre ihtiyaç duyduğu min. hav. miktarını hesaplar ve ilgili kontrol yöntemi seçilmişse'
    ' Min. Hav. sistemini bu bilgiye göre kontrol eder.\n\n'  : null;

     //Sensör Kalibrasyon
    kod=="info21" ? metin=' SEÇENEK 1:  Kurulum Ayarları → Adetler kısmından ısı sensörleri ölçüm yöntemi "Wifi Yöntemi" seçilirse wifi üzerinden en az bir kere bağlanmış'
    ' olan sensörler görünür olacaktır. Görünür haldeki bu sensörlerden yeşil renkte olanın sorunsuz bağlı olduğu kırmızı renkli olanın ise bağlantısında hata olduğu'
    ' anlamına gelir.Bu durumda sensör, wifi sağlayıcısı veya server PC kontrol edilmelidir. İlgili sensör üzerine tıklandığında ekranın alt tarafından sensör değerine'
    ' + ve - olarak kalibrasyon değerini ilave edebileceğiniz bir pencere açılır.\n\n'
    ' SEÇENEK 2:  Kurulum Ayarları → Adetler kısmından ısı sensörleri ölçüm yöntemi "Analog Yöntemi" seçilirse ısı sensörü adedi kadar sensör görünür olacaktır.'
    ' Görünür haldeki bu sensörlerden yeşil renkte olanı değerin kablolar üzerinden okunabildiğini, kırmızı renkli olanlar ise okunamadığını gösterir.'
    ' Bu durumda analog modul, sensör veya kablolar kontrol edilmelidir. İlgili sensör üzerine tıklandığında ekranın alt tarafından sensör değerine + ve - olarak'
    ' kalibrasyon değerini ilave edebileceğiniz bir pencere açılır.\n\n'
    ' Sadece yeşil rekteki sensörlere kalibrasyon değeri girilebilmektedir.\n\n\n'  : null;



     //Yemleme
    kod=="info22" ? metin='     YEMLEME sayfası, yem arabalarını istenilen saatte kümesin arkasına göndermeye, istenilen saatte de kümesin önüne getirmeye'
    ' yarayan parametrelerin girildiği sayfadır.\n\nÖncelikle YEM ÇIKIŞ 1, YEM ÇIKIŞ 2 ve YEM ÇIKIŞ 3 çıkışlarına istenilen zamanda görev atamak için yanındaki kutucukların'
    ' işaretlenmesi gerekmektedir. Bu kutucukların işaretlenebilmesi için KURULUM AYARLARI\'ndan ilgili çıkış işaretlenmiş ve PLC çıkış numarası atanmış olması gerekmektedir.'
    ' Eğer ilgili çıkış KURULUM AYARLARI\'ndan işaretlenmişse buradaki kutucuk işaretlendiğinde ileri-geri butonları ve zaman çizelgesi görünür olacaktır.'
    ' Sol tarafta bulunan ileri ve geri butonlarına tıklandığında sayfanın alt tarafında zaman atama diyalog penceresi açılacaktır. Açılan diyalog penceresinde'
    ' tanımlı saatlerden görevin icra edilmesini istediğiniz saatleri işaretleyebilirsiniz. Açılan diyalog penceresinde tanımlı tüm saatler için aynı anda işaretleme'
    ' yapabilirsiniz bir sınır bulunmamaktadır. Ana ekranda ilgili çıkış için atanmış zamanların kutucukları yeşil olacak, görev atanmamış zamanların kutucukları'
    ' siyah olacaktır.\n\n'
    ' Sistem zamanı görev atanan saate geldiğinde ilgili çıkış "Sinyal Süresi (sn)" parametresine girilen süre kadar çıkış verecektir.'  : null;


    //Izleme ANA SAYFA
    kod=="info23" ? metin='     İzleme ana sayfasıdır. Sistemi kontrol eden tüm unsurların verilerine bu sayfadan erişilebilir.'
    ' Bu sayfada sistemin hangi modda olduğu ve bazı ölçülen, hesaplanan ve kaydedilen veriler görüntülenir. IZLEME 1 , IZLEME 2 ve IZLEME 3 butonlarıyla'
    ' istenen kontrol unsurlarının anlık verileri görüntülenebilir.\n\n'  : null;

    
    kod=="info23a" ? metin='Son 24 saat içerisinde ölçülen en yüksek ortalama sıcaklık değerini gösterir'
    ' Bu sıcaklığı hangi saatte kaydettiğini "Max.OSic.Saati" parametresinde gösterir\n\n'  : null;

    kod=="info23b" ? metin='Son 24 saat içerisinde ölçülen en düşük ortalama sıcaklık değerini gösterir'
    ' Bu sıcaklığı hangi saatte kaydettiğini "Min.OSic.Saati" parametresinde gösterir\n\n'  : null;

    kod=="info23c" ? metin='Son 24 saat içerisinde ölçülen en yüksek nem değerini gösterir'
    ' Bu nem değerini hangi saatte kaydettiğini "Max.Nem.Saati" parametresinde gösterir\n\n'  : null;

    kod=="info23d" ? metin='Son 24 saat içerisinde ölçülen en düşük nem değerini gösterir'
    ' Bu nem değerini hangi saatte kaydettiğini "Min.Nem.Saati" parametresinde gösterir\n\n'  : null;


    //KONTROL
    kod=="info24" ? metin='   Sistemin kontrolünde görevli tüm unsurların otomatik modda çalışma parametrelerinin'
    ' belirlendiği sayfalara erişimin sağlandığı sayfadır.'  : null;


    //SİSTEM
    kod=="info25" ? metin='   Bu sayfa Kurulum, versiyon, saat&tarih, admin, kullanıcı, sistem start-stop'
    ' ayarları gibi sistemsel ayarlamaların yapıldığı sayfalara erişimin yapıldığı sayfadır. '  : null;



    //İZLEME 1
    kod=="info26" ? metin='     Fan, klepe, Isı Sensörler ve ped pompa motorlarının çalışma durumlarının'
    ' izlenebildiği ve anlık verilerin gösterildiği sayfadır. \n\n'  : null;

    //İZLEME 2
    kod=="info27" ? metin='     Bacafan, ısıtıcı, Air inlet ve sirkülasyon fanlarının çalışma durumlarının'
    ' izlenebildiği ve anlık verilerin gösterildiği sayfadır. \n\n'  : null;

    //İZLEME 3
    kod=="info28" ? metin='     Yemleme(yem arabaları) saatleri, su sayaç değerleri ve tüketimleri, aydınlatma'
    ' saatleri, silo ağırlıkları ve yem tüketim durumlarının izlenebildiği ve anlık verilerin'
    ' gösterildiği sayfadır. \n\n'  : null;


    //YARDIMCI OPSİYON
    kod=="info28" ? metin='     YARDIMCI OPSİYONLAR sayfasında sistemin kontrolünde görevli tüm kontrol unsurlarının'
    ' yönetimine yardımcı ek parametreler bulunmaktadır.\n\n'  : null;

    kod=="info28a" ? metin='    Eğer "Yüksek Nemde Tüm Fanlar Çalışsın" parametresi işaretlenirse'
    ' Kümes içi nem değeri KONTROL→SOĞ.&NEM  sayfasındaki Max. Nem değerinin üzerine çıktığında'
    ' tüm fanlar devreye girer. Kümes içi nem değeri Max. Nem değerinin KONTROL→SOĞ.&NEM sayfasındaki'
    ' Nem Fark kadar altına düştüğünde tüm fanların çalışması durumu sona erer ve fanlar normal işleyişte'
    ' çalışmalarına devam eder. Eğer "Dış Nem Üst Limit Aktif" seçeneği işaretlenirse "Dış Nem üst Limit"'
    ' parametresi görünür olacaktır ve dış ortam nem değeri bu değerin üzerinde ise Yüksek Nemde'
    ' tüm fanların devreye girme opsiyonu devre dışı olacaktır.'
    ' nem değerinin üstüne\n\n'  : null;

    kod=="info28b" ? metin='    Yakın sıcaklık sensörlerine göre klepe açıklıklarında'
    ' ek kontrol sağlayan ayarların bulunduğu sayfaya geçişi sağlar.\n\n'  : null;


    kod=="info28c" ? metin='    Ortalama sıcaklık değeri artışına göre ilgili fan'
    ' devreye girdiğinde sıcaklık değeri hemen düşmüş olsa dahi en az bu parametreye'
    ' girilen saniye kadar çalışır. \n\n'  : null;


    kod=="info28d" ? metin='    "Elek. Kesildiğinde Sistemi Durdur" seçeneği işaretlendiğinde'
    ' elektrik kesintisi durumunda tüm kontrol unsurlarının modunu otomatikten manuele alır'
    ' ve sistemi durdurur. Elektrik kesilip tekrar geldiğinde veya tünel fanları manuelden'
    ' otomatiğe alındığında çalışacak tüm fanlar bir anda devreye girip elektrik mekanizmasını'
    ' zorlamaması için "T.Fan Yumuşak Geçiş Döngüsü(Dn)" ve "T.Fan Yumuşak Geçiş Adedi"'
    ' parametreleri kullanılır. Sistem "T.Fan Yumuşak Geçiş Döngüsü(Dn)" parametresine girilen'
    ' sürede "T.Fan Yumuşak Geçiş Adedi" parametresine girilen adet kadar fanı devreye sokar.'
    ' Bu işlem çalışması gerekli tüm fanlar devreye girinceye kadar tekrar eder. \n\n'  : null;


    kod=="info28e" ? metin='    Günlük tutulan ve İZLEME-3 sayfasından erişilen su sayaç verileri'
    'her gün bu parametrede belirtilen saatte resetlenir.\n\n'  : null;


    kod=="info28f" ? metin='    Günlük tutulan ve İZLEME sayfasından erişilen Min-Max Sıc. ve '
    'Min-Max Nem verileri her gün bu parametrede belirtilen saatte resetlenir.\n\n'  : null;


    kod=="info28g" ? metin='    Günlük tutulan ve İZLEME-3 sayfasından erişilen yem tüketim'
    'verileri her gün bu parametrede belirtilen saatte resetlenir.\n\n'  : null;

    //Kurulum Ayarları
    kod=="info29" ? metin='    Sistem ilk kurulduğunda kontrol unsurlarıyla alakalı tüm kurulum'
    ' detaylarının tanımlandığı ayarların sayfalarına erişimi sağlayan sayfadır. Bu ayarlarda değişikliklerin'
    ' tüm sistemin işleyişine etkisi olduğundan yetkili kişiden başkasının bu ayarlarda değişiklik'
    ' yapmaması gerekir.\n\n'  : null;

    //Adetler
    kod=="info30" ? metin='    Bu sayfada sistemin kontrolünde kullanılacak bazı kontrol unsurlarının adetleri,'
    ' bazı kontrol unsurlarının da var-yok bilgisi tanımlanabilmektedir. Isı sensör sayısı bölümünde hem ısı'
    ' sensör sayısı tanımlanmaktadır hem de bu alanda bulunan analog veya wifi ikonlarına tıklayarak'
    ' sensörlerin bağlantı tipini de tanımlanabilmektedir. Default olarak analog seçilidir.\n\n'  : null;

    //Air Inlet & Sirk.Fanı
    kod=="info31" ? metin='    Bu sayfada Air Inlet aç-kapa çıkışlarının ve Sirkülasyon fanlarını çalıştıran'
    ' çıkışın atanması yapılmaktadır. Atama yapılırken sayfanın sağ tarafında bulunan "ÇIKIŞLAR" listesine göre'
    ' çıkış seçilmelidir. Mavi renkteki çıkışlar "kullanımda", gri renkteki çıkışlar "boşta" anlamındadır.'
    ' Tüm işlemler tamamlandığında "VERİLERİ GÖNDER" butonuna tıklanarak'
    ' veriler sisteme kaydedilmek üzere göderilmelidir.\n\n'  : null;

    //Baca Fan Haritası
    kod=="info32" ? metin='    Çatı üzerindeki soru işareti ikonlarına tıklayarak'
    ' bacafanlarının yerleşimini yapabilirsiniz. Yerleşimi tamamladıktan sonra "HARITAYI ONAYLA"'
    ' butonuna tıklayarak haritayı onaylayabilirsiniz. Sistem, yerleştirdiğiniz baca fanlarına belirli'
    ' bir sırayla otomatik olarak numara verecektir, istenirse bacafan ikonları üzerine'
    ' tıklanarak bu numaraları değiştirebilirsiniz. Bacafan yerleşimini sıfırdan yapmak için'
    ' "HARİTAYI SIFIRLA" butonuna tıklayarak haritayı sıfırlayabilirsiniz.\n\nBacafanları'
    ' dijital çıkış ile kontrol edilecekse "Dijital Çıkış", analog çıkışla kontrol edilecekse'
    ' "Analog Çıkış" işaretlenmelidir. Dijital Çıkış işaretlendiğinde çıkışın atanacağı'
    ' atama butonu, Analog Çıkış işaretlendiğinde analog çıkış seçenekleri olan "0-10V"'
    ' "4-20mA" seçenekleri görünür olacaktır. Bu seçeneklerden uygun olanı seçilmelidir.'
    ' \n\nEğer bacafanları kapaklı ise "Bacafan Kapak Var mı?" seçeneği işaretlenmeli ve'
    ' görünür olan Kapak Aç Çıkış No ve Kapak Kapa Çıkış No atamaları yapılmalıdır.'
    ' Çıkış ataması yapılırken sayfanın sağ tarafında bulunan "ÇIKIŞLAR" listesine göre'
    ' çıkış seçilmelidir. Mavi renkteki çıkışlar "kullanımda", gri renkteki çıkışlar'
    ' "boşta" anlamındadır. Tüm işlemler tamamlandığında "VERİLERİ GÖNDER" butonuna tıklanarak'
    ' veriler sisteme kaydedilmek üzere göderilmelidir.\n\n'  : null;


    //Diğer çıkışlar
    kod=="info33" ? metin='    Bu sayfada Alarm, Uyarı, Aydınlatma ve Yem Araba'
    ' ileri-geri çıkışlarının atamaları yapılır. Çıkış ataması yapılırken sayfanın sağ'
    ' tarafında bulunan "ÇIKIŞLAR" listesine göre çıkış seçilmelidir. Mavi renkteki çıkışlar'
    ' "kullanımda", gri renkteki çıkışlar "boşta" anlamındadır.\n\n3 farklı yem araba grupları'
    ' "Yem 1 Aktif" , "Yem 2 Aktif", "Yem 3 Aktif" seçenekleri aktif edilerek kontrol edilebilir'
    ' Aydınlatma çıkışı dimmerli olacaksa "Dimmer" seçeneği işaretlenmeli, dijital çıkış'
    ' olacaksa "Dimmer" seçeneği işaretlenmemelidir. Kümes içerisinde kaç adet su sayacı varsa'
    ' \n\n"Su Sayaç Sayısı" parametresine girilmelidir. Su sayaç sayısı genelde sıra sayısı ile'
    ' aynıdır. Takılan su sayaçları kaç litrede bir pals sinyali veriyorsa "Pals Başına Litre"'
    ' parametresine girilmelidir. Kümeste katlara su gitmediğini tespit eden sensör kullanılacaksa'
    ' bu sensörden gelecek bilginin sistemde alarm vermesi isteniyorsa "Su Alarm" seçeneği'
    ' işaretlenmelidir. Tüm işlemler tamamlandığında "VERİLERİ GÖNDER" butonuna tıklanarak'
    ' veriler sisteme kaydedilmek üzere göderilmelidir.\n\n'  : null;


    //Fan Haritası
    kod=="info34" ? metin='    Bina üzerindeki soru işareti ikonlarına tıklayarak'
    ' tünel fanlarının yerleşimini yapabilirsiniz. Yerleşimi tamamladıktan sonra "HARITAYI ONAYLA"'
    ' ikonuna tıklayarak haritayı onaylayabilirsiniz. Onaylı haritada fanlar üzerine tıklayarak'
    ' fanlara numara ve çıkış ataması yapabilirsiniz. İstenirse sağ üstte bulunan "OTO" butonunu'
    ' kullanarak belirli bir sırayla çıkış atamalarını otomatik olarak yapabilirsiniz.'
    ' Tünel fanlarının yerleşimini sıfırdan yapmak için'
    ' "HARİTAYI SIFIRLA" ikonuna tıklayarak haritayı sıfırlayabilirsiniz.\n\n'
    ' Çıkış ataması yapılırken sayfanın sağ tarafında bulunan "ÇIKIŞLAR" listesine göre'
    ' çıkış seçilmelidir. Mavi renkteki çıkışlar "kullanımda", gri renkteki çıkışlar'
    ' "boşta" anlamındadır.Tüm işlemler tamamlandığında "VERİLERİ GÖNDER" ikonuna tıklanarak'
    ' veriler sisteme kaydedilmek üzere göderilmelidir. \n\n'  : null;


    //Fan Kontrol Yöntemi
    kod=="info35" ? metin='    Bu sayfada Tünel fanlarının kontrol yönteminin seçimi yapılmaktadır.'
    ' Sistemde baca fanı olduğunda "Klasik Kontrol" yöntemi devre dışıdır, seçilemez. Baca fanı olmayan'
    ' CİVCİV veya BROYLER kafeslerinde "PID Kontrol" yöntemi devre dışıdır, seçilemez. "Lineer'
    ' Kontrol" yöntemi tüm kafesler ve durumlar için seçilebilir yöntemidir\n\n'  : null;

    kod=="info35a" ? metin='    Klasik kontrol yönteminde her bir fan için çalışma sıcaklığı'
    ' belirlenir. Ortalama sıcaklık bu çalışma sıcaklığına yükseldiğinde'
    ' fan çalışır, bu çalışma sıcaklığının altına düştüğünde fan durur.\n\n'  : null;

    kod=="info35b" ? metin='    Lineer kontrol yönteminde seçilen iki sıcaklık arasında fan sayısını'
    ' sıfırdan maksimuma çıkarır. Örn. 22 ile 28 derece arasında 22 derecede 1 fan 28 derecede'
    ' maksimum fan olacak şekilde doğrusal olarak fan sayısını artırır. 28 derecenin üzerinde maksimum'
    ' fan çalışmaya devam eder.\n\n'  : null;

    kod=="info35c" ? metin='    PID kontrol yönteminde PLC ortam sıcaklığının ısınma ve soğuma hızlarını'
    ' algılar ve bu hızları durdurabilecek yeterlikte fan sayısını hesaplar ve devreye sokar. Kümes'
    ' için ortalama sıcaklığı istenen sıcaklığa yakın tutmak için en ideal kontrol yöntemidir.\n\n'  : null;

    //GİRİŞLER
    kod=="info36" ? metin='    Bu sayfada sistemde aktif halde kullanılacak tüm girişler için giriş'
    ' atamaları yapılabilmektedir. Herbir atama için tek tek giriş ataması yapılabileceği gibi'
    ' "Otomatik Ata" butonuna tıklayarak belirli bir sırayla giriş atamasını otomatik olarak'
    ' yapabilirsiniz.Tüm işlemler tamamlandığında "VERİLERİ GÖNDER" butonuna tıklanarak'
    ' veriler sisteme kaydedilmek üzere göderilmelidir. \n\n'  : null;

    //Isı Sensör Haritası
    kod=="info37" ? metin='    Bina üzerindeki soru işareti ikonlarına tıklayarak'
    ' isi sensörlerinin yerleşimini yapabilirsiniz. Yerleşimi tamamladıktan sonra "HARITAYI ONAYLA"'
    ' butonuna tıklayarak haritayı onaylayabilirsiniz. Sistem, yerleştirdiğiniz ısı sensörlerine belirli'
    ' bir sırayla otomatik olarak numara verecektir, istenirse ısı sensör ikonları üzerine'
    ' tıklanarak bu numaraları değiştirebilirsiniz. Isı sensör yerleşimini sıfırdan yapmak için'
    ' "HARİTAYI SIFIRLA" butonuna tıklayarak haritayı sıfırlayabilirsiniz.\n\n'
    ' SEÇENEK 1:  Kurulum Ayarları → Adetler kısmından ısı sensörleri ölçüm yöntemi'
    ' "Wifi Yöntemi" seçilirse wifi üzerinden en az bir kere bağlanmış olan sensörler "Kayıtlı Sensörler"'
    ' bölümünde görünür olacaktır. Görünür haldeki bu sensörlerden yeşil renkte olanın sorunsuz bağlı olduğu'
    ' kırmızı renkli olanın ise bağlantısında hata olduğu anlamına gelir.Bu durumda sensör, wifi sağlayıcısı'
    ' veya server PC kontrol edilmelidir. Görünür haldeki sensörlerin üzerine tıklanarak, bu sensör alttaki'
    ' haritada hangi noktadaysa o noktada bulunan ısı sensör numarası atanmalıdır.\n\n'
    ' SEÇENEK 2:  Kurulum Ayarları → Adetler kısmından ısı sensörleri ölçüm yöntemi "Analog Yöntemi" seçilirse'
    ' ısı sensörü adedi kadar sensör görünür olacaktır. Görünür haldeki bu sensörlerden yeşil renkte olanı'
    ' değerin kablolar üzerinden okunabildiğini, kırmızı renkli olanlar ise okunamadığını gösterir.'
    ' Bu durumda analog modul, sensör veya kablolar kontrol edilmelidir.Görünür haldeki sensörlerin'
    ' üzerine tıklanarak, bu sensör alttaki haritada hangi noktadaysa o noktada bulunan ısı sensör'
    ' numarası atanmalıdır.Tüm işlemler tamamlandığında "VERİLERİ GÖNDER" butonuna tıklanarak'
    ' veriler sisteme kaydedilmek üzere göderilmelidir.\n\n\n'  : null;


    //Isıtıcı Haritası
    kod=="info38" ? metin='    Bina üzerindeki soru işareti ikonlarına tıklayarak'
    ' ısıtıcıların yerleşimini yapabilirsiniz. Yerleşimi tamamladıktan sonra "HARITAYI ONAYLA"'
    ' butonuna tıklayarak haritayı onaylayabilirsiniz. Onaylı haritada ısıtıcılar üzerine tıklayarak'
    ' ısıtıcılara "Adetler" kısmında tanımlanan ısıtıcı grup sayısı miktarınca grup numarası'
    ' ataması yapabilirsiniz."Adetler" kısmında 1 adet ısıtıcı tanımlanmışsa harita üzerinde tanımlı'
    ' tüm ısıcılara grup 1 ataması yaparak tüm ısıtıcıların tek çıkıştan kontrol edilmesini'
    ' sağlayabilirsiniz. "Adetler" kısmında tanımlı ısıtıcı sayısı miktarınca çıkış atama butonu'
    ' görünür olacaktır. Isıtıcıların yerleşimini sıfırdan yapmak için'
    ' "HARİTAYI SIFIRLA" butonuna tıklayarak haritayı sıfırlayabilirsiniz.\n\n'
    ' Çıkış ataması yapılırken sayfanın sağ tarafında bulunan "ÇIKIŞLAR" listesine göre'
    ' çıkış seçilmelidir. Mavi renkteki çıkışlar "kullanımda", gri renkteki çıkışlar'
    ' "boşta" anlamındadır.Tüm işlemler tamamlandığında "VERİLERİ GÖNDER" butonuna tıklanarak'
    ' veriler sisteme kaydedilmek üzere göderilmelidir. \n\n'  : null;


    //Klepe Haritası
    kod=="info39" ? metin='    Duvarlar üzerindeki soru işareti ikonlarına tıklayarak'
    ' klepelerin yerleşimini yapabilirsiniz. Yerleşimi tamamladıktan sonra "HARITAYI ONAYLA"'
    ' butonuna tıklayarak haritayı onaylayabilirsiniz. Onaylı haritada klepeler üzerine tıklayarak'
    ' klepelere hem numara hem de aç-kapa çıkış ataması yapabilirsiniz. iki klepeyi'
    ' aynı aç-kapa çıkışlarıyla kontrol etmek istiyorsak her iki klepeye de aynı no ve aç-kapa çıkışları'
    ' atanmalıdır. Tüm klepeler ayrı ayrı çıkışlarla kontrol edilecekse, tüm klepelere farklı no ve'
    ' farklı aç-kapa çıkışı atanmalıdır. Klepelerin yerleşimini sıfırdan yapmak için'
    ' "HARİTAYI SIFIRLA" butonuna tıklayarak haritayı sıfırlayabilirsiniz.\n\n'
    ' Çıkış ataması yapılırken sayfanın sağ tarafında bulunan "ÇIKIŞLAR" listesine göre'
    ' çıkış seçilmelidir. Mavi renkteki çıkışlar "kullanımda", gri renkteki çıkışlar'
    ' "boşta" anlamındadır.Tüm işlemler tamamlandığında "VERİLERİ GÖNDER" butonuna tıklanarak'
    ' veriler sisteme kaydedilmek üzere göderilmelidir. \n\n'  : null;


    //Klepe Kontrol Yöntemi
    kod=="info40" ? metin='    Bu sayfada klepelerin kontrol yönteminin seçimi yapılmaktadır.\n\n'  : null;

    kod=="info40a" ? metin='    Klasik kontrol yönteminde her bir klepe için çalışan fan sayısına'
    ' göre açılma oranı tayin edilir. Örn: fan sayısı 1\'den 10\'a yükselirken klepe açıklığı'
    ' 0\'dan 40\'a yükselsin, fan sayısı 10\'dan 20\'ye yükselirken klepe açıklığı 40\'dan 100\'e'
    ' yükselsin şeklinde tanımlamalar yapılabilir.\n\n'  : null;

    kod=="info40b" ? metin='    Tünel kontrol yönteminde tünel fanlarının toplam debisi uzunlukları'
    ' oranında klepelere pay edilir ve önden arkaya doğru sırayla klepeler çalışan fan sayısına göre'
    ' açılmaya başlar. Klepelerin hangi sırayla çalışacakları atanacak sıra numarasıyla tanımlanır.'
    ' Örn: Klepe No1:12m(ön), Klepe No2:30m(sağ) ve Klepe No3:30m(sol) uzunluklarına 3 klepenin'
    ' bulunduğu 24 fanlı kümeste fanlar klepelere uzunlukları oranında 4,10,10 şeklinde pay edilir.'
    ' Klepelerin hangi sırayla çalışacağını tayin eden sıra ataması da şu şekilde olsun: Klepe No1\'e '
    ' 1. sıra,  Klepe No2 ve No3\'e 2. Sıra ataması yapılsın. Klepe No2 ve No3\'e aynı sıra numarasının'
    ' atanması iki klepenin aynı anda aç-kapa yapacağı anlamına gelir. Bu durumda 4 fana kadar sadece ön'
    ' klepe devrede olur, 4 fan ile 24 fan arasında sağ-sol klepeler de doğru orantılı olarak açılır.\n\n'  : null;



    //MH Kontrol Yöntemi
    kod=="info41" ? metin='    Bu sayfada Min Hav. sisteminin kontrol yöntemi seçimi yapılmaktadır.\n\n'  : null;

    kod=="info41a" ? metin='    Klasik kontrol yönteminde arka duvar tünel fanları kullanılır.'
    ' 4 adet fana kadar tünel fanı minimum havalandırma için atanabilir ve atanan fanların tamamı'
    ' set değerinin üstündeki doğal bölgede sürekli, set değerinin altında fasılalı çalışır. Set'
    ' değerinin altında sıcaklık düştükçe devreye giren 4 ayrı fasıla degeri tanımlanabilir.Klasik'
    ' Kontrol yöntemi CİVCİV, BROILER ve bacafanı-airinlet olan TAVUK kafesleri için devre dışıdır.\n\n'  : null;

    kod=="info41b" ? metin='    Ağırlık kontrol yönteminde sistem girilen SÜRÜ→Hayvan Başına Min.Hav.'
    ' İhtiyacı(m2/h) kısmındaki parametreleri kullanarak hayvan yaşına göre ortalama ağırlığını ve'
    ' ilgili ağırlık için gerekli minimum havalandırmayı hesaplar ve bunu sağlayacak yeterli sayıdaki'
    ' fanı gerek sürekli gerekse fasılalı olarak çalıştırır. CİVCİV ve BROILER kümeslerinde sadece'
    ' bu yöntem geçerlidir, TAVUK kümeslerinde de kullanılabilir.\n\n'  : null;

    kod=="info41c" ? metin='    Hacim kontrol yönteminde sistem bazı parametreleri kullanarak iç'
    ' ortam hacmini yaklaşık olarak hesaplar ve yapılacak seçime göre her 5 dakikada veya her'
    ' 10 dakikada iç ortam hacmi kadar havayı dışarı atma prensibine göre yeterli sayıda fanı'
    ' gerek sürekli gerekse fasılalı olarak çalıştırır. CİVCİV ve BROILER kümesleri için devre dışıdır.'
    ' Sadece TAVUK kümesi için geçerlidir.\n\n'  : null;


    //Ped Haritası
    kod=="info42" ? metin='    Duvarlar üzerindeki soru işareti ikonlarına tıklayarak'
    ' ped pompalarının yerleşimini yapabilirsiniz. Yerleşimi tamamladıktan sonra "HARITAYI ONAYLA"'
    ' butonuna tıklayarak haritayı onaylayabilirsiniz. Onaylı haritada ped pompaları üzerine tıklayarak'
    ' ped pompalarına hem numara hem de çıkış ataması yapabilirsiniz. Ped pompalarının yerleşimini'
    ' sıfırdan yapmak için "HARİTAYI SIFIRLA" butonuna tıklayarak haritayı sıfırlayabilirsiniz.\n\n'
    ' Çıkış ataması yapılırken sayfanın sağ tarafında bulunan "ÇIKIŞLAR" listesine göre'
    ' çıkış seçilmelidir. Mavi renkteki çıkışlar "kullanımda", gri renkteki çıkışlar'
    ' "boşta" anlamındadır.Tüm işlemler tamamlandığında "VERİLERİ GÖNDER" butonuna tıklanarak'
    ' veriler sisteme kaydedilmek üzere göderilmelidir. \n\n'  : null;


    //Silo Haritası
    kod=="info43" ? metin='   Bina çevresindeki soru işareti ikonlarına tıklayarak'
    ' siloların yerleşimini yapabilirsiniz. Yerleşimi tamamladıktan sonra "HARITAYI ONAYLA"'
    ' butonuna tıklayarak haritayı onaylayabilirsiniz. Onaylı haritada silolar üzerine tıklayarak'
    ' silolara numara ataması yapabilirsiniz. Ped pompalarının yerleşimini'
    ' sıfırdan yapmak için "HARİTAYI SIFIRLA" butonuna tıklayarak haritayı sıfırlayabilirsiniz.\n\n'
    ' Tüm işlemler tamamlandığında "VERİLERİ GÖNDER" butonuna tıklanarak'
    ' veriler sisteme kaydedilmek üzere göderilmelidir. \n\n'  : null;


    //Temel ayarlar
    kod=="info44" ? metin='   Bu sayfada kafesle ilgili temel ayarlar tanımlanır. Kafes türü seçimi'
    ' yapılmalıdır. Her bir kümes için ayrı no atanmalı ve ayrı isim tanımlanmalıdır. Yönetici yetkinliği'
    ' gerektiren işlemlerde sadece yöneticilerin değişiklik yapabilmesini sağlamak için bir admin'
    ' şifresi belirlenmelidir. Şifre 4 haneli bir sayıdan oluşmalıdır. Şifreyi belirledikten ve şifre tekrar'
    ' bölümüne de girdikten sonra "ONAYLA" butonuna basıldığında yeni şifre aktifleşecektir. \n\n'  : null;


    //Bina, Dış Nem ve Debi
    kod=="info45" ? metin='   Bu sayfada hacim hesabının yapılabilmesi için bina en, boy ve yükseklik'
    ' metre olarak girilmelidir. "Hacim Oranı(%)" parametresine bina içerisindeki boşluk hacminin yüzdesi'
    ' girilmeidir. Minimum Havalandırma hesaplarının yapılabilmesi için "Tün. Fan Debi" parametresine'
    ' bir tünel fanının saatteki debisi girilmeli, "Baca Fan Debi" parametresine tüm bacafanlarının'
    ' saatteki toplam debisi girilmelidir. \n\nKlepelerin numaraları, en(X) ve boy(Y) uzunlukları'
    ' ilgili alanlara girilmeli ve aşağı ok ikonuna tıklanarak girilen uzunluklar kaydedilmelidir.'
    ' "Klepe Haritası" sayfasında 2 klepeye aynı numara verilmişse bu 2 klepenin boy(Y) uzunluklarının'
    ' toplamı Y(m) alanına girilmelidir. \n\n'  : null;


    //Genel Ayarlar
    kod=="info46" ? metin='    Sistemin kurulum, kontrol, kayıt ve izleme kapsamında tüm'
    ' parametrelerin bulunduğu sayfalara erişimi saylayan genel erişim sayfasıdır.\n\n'  : null;


    //YAZILIM
    kod=="info47" ? metin='    Yazılım tanımı, ismi ve versiyon numarası gibi detayların'
    ' bulunduğu sayfadır.\n\n'  : null;


    //START
    kod=="info48" ? metin='    Tüm kurulum ve kontrol parametreleri girildikten sonra, kontrol unsurlarını'
    ' otomatik moda almadan önce sistem bu sayfadan başlatılmalıdır. Aksi taktirde sistemde hiçbir şey çalışmaz.\n\n'  : null;


    //BAĞLANTI DURUMU
    kod=="info49" ? metin='    Sistemi kontrol eden unsurların birbiri ile haberleşmesini sağlayan ağda bir haberleşme'
    ' hatası olması durumunda hatalar bu sayfada listelenir. Listelenen hatalar üzerinde hata zamanı, hatanın meydana geldiği'
    ' ilk zamanı gösterir. Listelenen hatalar üzerine tıklandığında hata kodları ve çözüm önerileri bilgilerini görüntüleyebilirsiniz.'
    ' hata giderildikten sonra listedeki kırmızı renkli bağlantı ikonu yeşil olacaktır. Bu durumdayken "HATAYI RESETLE" butonuna'
    ' tıklayarak hatayı listeden kaldırabilirsiniz, ikon yeşil olmadan hatayı listeden kaldıramazsınız.\n\n'  : null;


    //ALARM AYARLARI
    kod=="info50" ? metin='    Sistemde tanımlı alarmlarla ve uyarılarla ilgili parametrelerin girildiği sayfadır. Alarm durumu maydana geldiğinde'
    ' pano üzerindeki kırmızı ışık yanar ve eğer alarmın kornası aktifse korna da çalar. Uyarı durumu meydana geldiğinde sadece pano üzerindeki sarı ışık yanar\n\n'  : null;

    kod=="info50a" ? metin='Kumes içi ortalama sıcaklık değeri bu parametreye girilen değerin altına düştüğünde sistem minimum sıcaklık alarmı verir.\n\n'  : null;
    
    kod=="info50b" ? metin='Kumes içi ortalama sıcaklık değeri bu parametreye girilen değerin üstüne çıktığında sistem maksimum sıcaklık alarmı verir.\n\n'  : null;

    kod=="info50c" ? metin='Kumes içi nem değeri bu parametreye girilen değerin altına düştüğünde sistem minimum nem alarmı verir.\n\n'  : null;
    
    kod=="info50d" ? metin='Kumes içi nem değeri bu parametreye girilen değerin üstüne çıktığında sistem maksimum nem alarmı verir.\n\n'  : null;

    kod=="info50e" ? metin='Ortalama sıcaklık değeri ve nem değeri alarm için belirlenen minimum değerlerin altına düştüğünde aynı şekilde'
    ' ortalama sıcaklık değeri ve nem değeri alarm için belirlenen maksimum değerlerin üstüne çıktığında bu parametrede belirtilen süre '
    ' kadar bekledikten sonra hala alarm şartları sürüyorsa alarmı devreye sokar. Bu parametrenin amacı anlık sıcaklık ve nem dalgalanmalarında'
    ' alarmın devreye girmesini engellemektir. Tavsiye edilen süre 10 sn\'dir.\n\n'  : null;

    kod=="info50f" ? metin='Her bir tünele bağlı sayaç için bu parametrede günlük minimum su tüketim miktarı belirlenir. Buna göre sayaçlardan herhangi'
    ' birindeki günlük tüketim miktarı bu parametreye girilen değerin altına düştüğünde alarm aktif olur. Bu alarm günlük su verilerinin resetlendiği'
    ' saatte verileri kontrol ederek devreye girer veya girmez. Günlük su verilerinin resetlendiği saatin girildiği parametre "YARDIMCI OPSIYONLAR"'
    ' sayfasındadır.\n\n'  : null;


    kod=="info50g" ? metin='Bu parametreye girilen gün kadar süre geçince sistem "ped bakım zamanı geldi" anlamında bir uyarı verir.'
    ' bakım yapılıp uyarı resetlendiğinde bir sonraki bakım zamanında tekrar uyarı vermek üzere süreç resetlenir.\n\n'  : null;


    kod=="info50h" ? metin='Bu parametreye girilen gün kadar süre geçince sistem "sistem bakım zamanı geldi" anlamında bir uyarı verir.'
    ' bakım yapılıp uyarı resetlendiğinde bir sonraki bakım zamanında tekrar uyarı vermek üzere süreç resetlenir.\n\n'  : null;

    kod=="info50i" ? metin='Bu butona bir kez basıldığında kornayı "Susma Süresi(Sn)" parametresine girilen süre kadar susturur.'
    ' Bu sayede alarmı meydana getiren sorunu giderene kadar alarmın çalması engellenmiş olur. \n\n'  : null;

    //HARİCİ ALARMLAR
    kod=="info51" ? metin='Sistemde tanımlı olmayan alarm durumları sisteme ilave edilmek istendiğinde bu alarmlar PLC\'nin harici alarm'
    ' girişine sinyal verilmek suretiyle eklenebilir. Hangi ekstra alarmların harici alarm girişine sinyal verdiğini bu sayfadaki metin ekle'
    ' kısmına alarm tanımını girip "EKLE" butonuna basarak listeye ekleyebilirsiniz. Bu sayade sistem harici alarm verdiğinde buna sebep olan alarmı listeden kontrol'
    ' ederek tespit edebilir, ilgili çözüm için müdahalede bulunabilirsiniz.\n\n'  : null;

    //ALARM KORNA İPTAL
    kod=="info52" ? metin='     Sistemde tanımlı alarmlardan hangisi meydana geldiğinde korna aktif olsun veya olmasın durumunun belirlendiği sayfadır.'
    ' İlgili alarm için buton pasif yapılırsa ekranda sol üstte alarm ikonu kırmızı yanar ve alarm durumu aktif alarmlarda görüntülenir ancak pano üzerindeki'
    ' kırmızı ışık yanmaz ve korna da çalmaz.\n\n'  : null;

    //AKTİF ALARMLAR
    kod=="info53" ? metin='     Sistemde tanımlı alarmlar ve uyarılar meydana geldiğinde aktif alarmlar ve aktif uyarılar bu sayfada görüntülenir.'
    ' Aktif alarm sorunları düzeltildikten sonra "LİSTEYİ GÜNCELLE" butonuna tıklanarak listede görüntülenen alarmların kırmızı olan'
    ' alarm ikonlarının renginin yeşile dönmesi beklenir. Yeşile dönerse alarm sinyali kesilmiş, sorun çözülmüş demektir. "LİSTEYİ GÜNCELLE" '
    ' butonuna tıkandığı halde ikon yeşile dönmüyorsa alarm sorunu çözülmemiş, alarm sinyali hala geliyor demektir durum tekrar kontrol  edilmelidir. Alarm ikonu'
    ' yeşile döndükten sonra ilgili alarmı listeden silmek için "ALARMI KALDIR" butonuna tıklayınız. Aynı şekilde ilgili uyarı şartları çözülmüşse "LİSTEYİ GÜNCELLE"'
    ' butonuna tıklandığında uyarı ikonu sarıdan yeşile döner. Bu işlem sonrasında "UYARIYI KALDIR" butonuna tıklayarak ilgili uyarıyı listeden kaldırabilirsiniz.\n\n'  : null;


    //SIC ve NEM LOGLARI
    kod=="info54" ? metin='     Ortalama Sıcaklık, hissedilir sıcaklık, tüm sıcaklık sensörlerinin değerleri ve iç-dış nem değerlerinin log kayıtlarına bu sayfadan'
    ' erilebilmektedir. "Kayıt Türü" parametresinden kayıt türü seçilir. "Log Periyot" parametresinden 5dk, 10dk, 15dk, 30dk ve 60dk seçeneklerinden biri seçildiğinde'
    ' kayıtlı veriler bu parametrede belirtilen aralıklarla listelenir. Hangi tarih aralığındaki kayıtlar getirilsin isteniyorsa "Tarih İlk" ve "Tarih Son" parametrelerine'
    ' istenilen aralık girilir ve "GETİR" butonuna basılır. Burada dikkat edilmesi gereken nokta bir defade en fazla 1 aylık veri çağrılabilir. "Tarih İlk" ve "Tarih Son"'
    ' parametrelerinin her ikisi için de yıl ve ay aynı olacak şekilde girilmelidir. Veriler getirildiğinde tespit edilen "En yüksek" ve "En düşük" değerler'
    ' o anda çağırılan listedeki en yüksek ve en düşük değerlerdir.\n\n'  : null;


    //ALARM ve UYARI LOGLARI
    kod=="info55" ? metin='     Geçmişte meydana gelmiş alarm ve uyarı log kayıtlarına bu sayfadan erilebilmektedir.'
    ' "Kayıt Türü" parametresinden kayıt türü seçilir. Hangi tarih aralığındaki kayıtlar getirilsin isteniyorsa "Tarih İlk" ve "Tarih Son" parametrelerine'
    ' istenilen aralık girilir ve "GETİR" butonuna basılır. Burada dikkat edilmesi gereken nokta bir defade en fazla 1 aylık veri çağrılabilir. "Tarih İlk" ve "Tarih Son"'
    ' parametrelerinin her ikisi için de yıl ve ay aynı olacak şekilde girilmelidir.\n\n'  : null;


    //KW DEĞERLERİ
    kod=="info57" ? metin='     Bu sayfada sistemde kullanılan ve elektrik tüketimine sebep olan kontrol unsurlarının kurulu KW değerleri'
    ' sistemin elektrik tüketimini hesaplayabilmesi için girilmelidir.\n\n     Tünel Fanı, klepe, ped pompa, air inlet ve ısıtıcı için sadece 1 adedinin'
    ' KW değeri girilmelidir. Bacafanları, sirkülasyon fanları ve aydınlatma sisteminin ise toplam KW değerleri girilmelidir.\n\n'  : null;

    //DATA LOGLAR
    kod=="info58" ? metin='     Bu sayfada sistemin geriye dönük tuttuğu "Sıcaklık ve Nem" , "Alarm / Uyarı" , "Tüketim" ve "Parametre"'
    ' loglarına erişim sağlanmaktadır. İstenilen veri geçmişine, seçilen tarih aralığında erişilebilmektedir. \n\n'  : null;


    //STRES & KONFOR GRAFİĞİ
    kod=="info59" ? metin='     Hayvanların sıcaklığa ve neme bağlı stres ve konfor durumlarını gösterir grafiktir. Kümes içerisindeki ortalama sıcaklık, hissedilir'
    ' sıcaklık ve bağıl nemin hayvanın vücudunda meydana getirdiği stresin derecesini anlamaya yönelik analiz yapılmasına olanak sağlar.\n\n'
    ' Normal alan:\n'
    ' Hayvanın sıcaklık stresine girmediği alandır.\n\n'
    ' 1. Uyarı alanı\n'
    ' Verimlilik düşer, performans kaybı başlar.\n\n'
    ' 2. Uyarı alanı:\n'
    ' Performans kaybı artarak devam eder, tüketimler dengesizleşir.\n\n'
    ' Tehlike alanı:\n'
    ' Yüksek katlarda ilk ölümler başlar. Organlarda kalıcı hasar vakaları görülür.\n\n'
    ' Ölüm alanı:\n'
    ' Yüksek oranlarda ölüm vakaları meydana gelir.\n\n'  : null;


    //LOG ve GRAFİK
    kod=="info60" ? metin='   Bu sayfa ile geçmişe dönük tutulan tüm loglara ve sistemin analiz edilmesi için ihtiyaç duyulan tüm'
    ' grafiklere erişim sağlanmaktadır.'  : null;

    //TÜKETİM LOGLARI
    kod=="info61" ? metin='     Geçmişte ölçülmüş elektrik, su ve yem tüketim değerlerinin log kayıtlarına bu sayfadan erilebilmektedir.'
    ' "Kayıt Türü" parametresinden kayıt türü seçilir. Hangi tarih aralığındaki kayıtlar getirilsin isteniyorsa "Tarih İlk" ve "Tarih Son" parametrelerine'
    ' istenilen aralık girilir ve "GETİR" butonuna basılır. Burada dikkat edilmesi gereken nokta bir defade en fazla 1 aylık veri çağrılabilir. "Tarih İlk" ve "Tarih Son"'
    ' parametrelerinin her ikisi için de yıl ve ay aynı olacak şekilde girilmelidir.\n\n'  : null;

    //PARAMETRE LOGLARI
    kod=="info62" ? metin='     Sistemde her bir parametre değişikliği, bu değişikliği hangi kullanıcı yaptı bilgisiyle birlikte kaydedilir. Kaydedilen bu verilere'
    ' bu sayfadan erişilebilmektedir. Hangi tarih aralığındaki kayıtlar getirilsin isteniyorsa "Tarih İlk" ve "Tarih Son" parametrelerine'
    ' istenilen aralık girilir ve "GETİR" butonuna basılır. Burada dikkat edilmesi gereken nokta bir defade en fazla 1 aylık veri çağrılabilir. "Tarih İlk" ve "Tarih Son"'
    ' parametrelerinin her ikisi için de yıl ve ay aynı olacak şekilde girilmelidir.\n\n'  : null;


    //GRAFİKLER
    kod=="info63" ? metin='     Bu sayfada sistem ve hayvanlar hakkında analiz yapılmasına olanak veren çeşitli verilerin karşılaştırılarak sunulduğu'
    ' grafik sayfalarına erişim sağlanmaktadır.\n\n'  : null;


    //SICAKLIK ve NEM GRAFİĞİ
    kod=="info64" ? metin='     Bu grafikte seçilen gün içerisinde "ortalama Sıcaklık", "Hissedilir Sıcaklık" , "İç nem" ve "Dış Nem" verilerinin zamana göre'
    ' değişiklikleri görüntülenir. Veriler grafiğe 15 dk\'lık ölçüm sıklığı ile yansıtılır. Veriler aynı zamanda grafiğin sağ tarafındaki gri alanda da metin olarak'
    ' listelenir. Bu alanda görüntülenmesi istenen veri türü "GETİR" butonunun sağında bulunan veri türleri işaretlenerek ayarlanır. Gri alanda metin olarak listelenen'
    ' verilerden kırmızı olan maksimum değeri, mavi olan minimum değeri, siyah olanlar da ara değeri ifade eder. \n\n'  : null;


     //GÜNLÜK SICAKLIK ve SU TÜKETİM GRAFİĞİ
    kod=="info65" ? metin='     Bu grafikte seçilen gün içerisinde "ortalama Sıcaklık" değerine göre meydana gelen "Su Tüketimi" görüntülenir.'
    ' Veriler grafiğe 15 dk\'lık ölçüm sıklığı ile yansıtılır. Belirtilen su tüketim değeri ilgili 15 dk içerisinde meydana gelen toplam su tüketim değeridir.'
    ' Veriler aynı zamanda grafiğin sağ tarafındaki gri alanda da metin olarak'
    ' listelenir. Bu alanda görüntülenmesi istenen veri türü "GETİR" butonunun sağında bulunan veri türleri işaretlenerek ayarlanır. Gri alanda metin olarak listelenen'
    ' verilerden kırmızı olan maksimum değeri, mavi olan minimum değeri, siyah olanlar da ara değeri ifade eder. \n\n'  : null;


    //AYLIK ELEKTRİK TÜKETİM GRAFİĞİ
    kod=="info66" ? metin='     Bu grafikte seçilen ay içerisinde gün bazında hesaplanan toplam elektrik tüketimi ve hayvan başına düşen elektrik tüketimi görüntülenir'
    ' Veriler grafiğe 1 günlük ölçüm sıklığı ile yansıtılır. Belirtilen elektrik tüketim değeri ilgili gün içerisinde meydana gelen toplam elektrik tüketim değeridir.'
    ' Veriler aynı zamanda grafiğin sağ tarafındaki gri alanda da metin olarak'
    ' listelenir. Bu alanda görüntülenmesi istenen veri türü "GETİR" butonunun sağında bulunan veri türleri işaretlenerek ayarlanır. Gri alanda metin olarak listelenen'
    ' verilerden kırmızı olan maksimum değeri, mavi olan minimum değeri, siyah olanlar da ara değeri ifade eder. \n\n'  : null;



    //AYLIK SU TÜKETİM GRAFİĞİ
    kod=="info67" ? metin='     Bu grafikte seçilen ay içerisinde gün bazında hesaplanan toplam su tüketimi ve hayvan başına düşen su tüketimi görüntülenir'
    ' Veriler grafiğe 1 günlük ölçüm sıklığı ile yansıtılır. Belirtilen su tüketim değeri ilgili gün içerisinde meydana gelen toplam su tüketim değeridir.'
    ' Veriler aynı zamanda grafiğin sağ tarafındaki gri alanda da metin olarak'
    ' listelenir. Bu alanda görüntülenmesi istenen veri türü "GETİR" butonunun sağında bulunan veri türleri işaretlenerek ayarlanır. Gri alanda metin olarak listelenen'
    ' verilerden kırmızı olan maksimum değeri, mavi olan minimum değeri, siyah olanlar da ara değeri ifade eder. \n\n'  : null;


    //AYLIK YEM TÜKETİM GRAFİĞİ
    kod=="info68" ? metin='     Bu grafikte seçilen ay içerisinde gün bazında hesaplanan toplam yem tüketimi ve hayvan başına düşen yem tüketimi görüntülenir'
    ' Veriler grafiğe 1 günlük ölçüm sıklığı ile yansıtılır. Belirtilen yem tüketim değeri ilgili gün içerisinde meydana gelen toplam yem tüketim değeridir.'
    ' Veriler aynı zamanda grafiğin sağ tarafındaki gri alanda da metin olarak'
    ' listelenir. Bu alanda görüntülenmesi istenen veri türü "GETİR" butonunun sağında bulunan veri türleri işaretlenerek ayarlanır. Gri alanda metin olarak listelenen'
    ' verilerden kırmızı olan maksimum değeri, mavi olan minimum değeri, siyah olanlar da ara değeri ifade eder. \n\n'  : null;















    kod=="alarminfo1" ? metin='DURUM : Pano üzerindeki veya seri bağlı başka bir noktadaki Acil Stop butonuna basıldığında bu alarm aktif olur.'
    ' Acil stop butonuna basıldığında ekran ve kontrol sistemi enerjisi kesilmez sadece tüm kontrol unsurlarını çalıştıran'
    ' kumanda sinyali kesilir ve hiçbirşey çalışmaz.\n\n'
    'ÇÖZÜM: Acil durum ortadan kalktığında butonu tekrar serbest bırakınız. Herhangi bir acil stop butonuna basılmadan bu alarm aktif'
    ' olduysa aradaki kablo ve klemens bağlantılarında temassızlık olup olmadığı kontrol edilmelidir. ' : null;
    kod=="alarminfo2" ? metin='DURUM: Kurulum sırasında motorların doğru yönde dönmesi için belirlenen faz sırası değiştiğinde'
    ' ve fazlardan biri veya ikisi kesilip faz kaybı meydana geldiğinde bu alarm aktif olur.\n\n'
    'ÇÖZÜM: Prokis panosuna enerji sağlayan'
    ' panonuzu, trafonuzu veya jeneratörünüzü kontrol ediniz. Faz sırası değişmeden veya faz kaybı olmadan'
    ' bu alarm aktif olduysa aradaki kablo ve klemens bağlantılarında veya faz kontrol rölesinde bir sorun oluşmuştur.' : null;
    kod=="alarminfo3" ? metin='DURUM: Şebeke elektrik kesildiğinde veya Prokis panosunun ana enerji sigortası attığında'
    ' bu alarm aktif olur.\n\n'
    'ÇÖZÜM: Şebeke enerjinizi ve ana sigortayı kontrol ediniz. Şebeke enerjisi kesilmeden veya'
    ' ana sigorta atmadan bu alarm aktif olduysa aradaki kablo ve klemens bağlantıları kontrol edilmedir.' : null;
    kod=="alarminfo4" ? metin='DURUM: Tünel fan motorlarından birinin termik ve motor koruma sigortası atarsa bu alarm aktif olur.\n\n'
    'ÇÖZÜM: Motor sigortası; mekanik zorlanma, fazlar arasında temas meydana gelmesi, motor ve sigorta arızası gibi sebeplerle'
    ' meydana gelir. Bu noktalar kontrol edilmelidir. Herhangi bir sigorta atmadan bu alarm aktif olduysa '
    ' aradaki kablo ve klemens bağlantıları kontrol edilmelidir.' : null;

    kod=="alarminfo5" ? metin='DURUM: Klepe motorlarından birinin termik ve motor koruma sigortası atarsa bu alarm aktif olur.\n\n'
    'ÇÖZÜM: Motor sigortası; mekanik zorlanma, fazlar arasında temas meydana gelmesi, motor ve sigorta arızası gibi sebeplerle'
    ' meydana gelir. Bu noktalar kontrol edilmelidir. Herhangi bir sigorta atmadan bu alarm aktif olduysa '
    ' aradaki kablo bağlantıları kontrol edilmelidir.' : null;

    kod=="alarminfo6" ? metin='DURUM: Ped pompa motorlarından birinin termik ve motor koruma sigortası atarsa bu alarm aktif olur.\n\n'
    'ÇÖZÜM: Motor sigortası; mekanik zorlanma, fazlar arasında temas meydana gelmesi, motor ve sigorta arızası gibi sebeplerle'
    ' meydana gelir. Bu noktalar kontrol edilmelidir. Herhangi bir sigorta atmadan bu alarm aktif olduysa '
    ' aradaki kablo bağlantıları kontrol edilmelidir.' : null;

    kod=="alarminfo7" ? metin='DURUM: Air inlet motorlarından birinin termik ve motor koruma sigortası atarsa bu alarm aktif olur.\n\n'
    'ÇÖZÜM: Motor sigortası; mekanik zorlanma, fazlar arasında temas meydana gelmesi, motor ve sigorta arızası gibi sebeplerle'
    ' meydana gelir. Bu noktalar kontrol edilmelidir. Herhangi bir sigorta atmadan bu alarm aktif olduysa '
    ' aradaki kablo bağlantıları kontrol edilmelidir.' : null;

    kod=="alarminfo8" ? metin='DURUM: Baca fan  motorlarından birinin termik ve motor koruma sigortası atarsa bu alarm aktif olur.\n\n'
    'ÇÖZÜM: Motor sigortası; mekanik zorlanma, fazlar arasında temas meydana gelmesi, motor ve sigorta arızası gibi sebeplerle'
    ' meydana gelir. Bu noktalar kontrol edilmelidir. Herhangi bir sigorta atmadan bu alarm aktif olduysa '
    ' aradaki kablo bağlantıları kontrol edilmelidir.' : null;

    kod=="alarminfo9" ? metin='DURUM: Isıtıcılardan birinin termik ve motor koruma sigortası atarsa bu alarm aktif olur.\n\n'
    'ÇÖZÜM: Motor sigortası; mekanik zorlanma, fazlar arasında temas meydana gelmesi, motor ve sigorta arızası gibi sebeplerle'
    ' meydana gelir. Bu noktalar kontrol edilmelidir. Herhangi bir sigorta atmadan bu alarm aktif olduysa '
    ' aradaki kablo bağlantıları kontrol edilmelidir.' : null;

    kod=="alarminfo10" ? metin='DURUM: Sirk. fan motorlarından birinin termik ve motor koruma sigortası atarsa bu alarm aktif olur.\n\n'
    'ÇÖZÜM: Motor sigortası; mekanik zorlanma, fazlar arasında temas meydana gelmesi, motor ve sigorta arızası gibi sebeplerle'
    ' meydana gelir. Bu noktalar kontrol edilmelidir. Herhangi bir sigorta atmadan bu alarm aktif olduysa '
    ' aradaki kablo bağlantıları kontrol edilmelidir.' : null;
    kod=="alarminfo11" ? metin='DURUM: Her bir tüneldeki su hatlarına su gidip gitmediğini tespit eden ayrı bir sistemden gelen alarm'
    ' sinyali aktif olduğunda bu alarm aktif olur.\n\n ÇÖZÜM: Bu alarm aktif olduğunda ilgili tünelin su hatları kontrol edilmedir.' : null;
    kod=="alarminfo12" ? metin='DURUM: İç ortam ortalama sıcaklık değeri ALARM AYARLARI sayfasında belirtilen minimum sıcaklık değerinin'
    ' "Alarm Gecikmesi" parametresinde belirtilen süre kadar altında kalırsa bu alarm aktif olur.\n\nÇÖZÜM: Sistemde arızalı bir unsur olup'
    ' olmadığı veya kontrol parametrelerinin doğru girilip girilmediği kontrol edilmelidir.' : null;
    kod=="alarminfo13" ? metin='DURUÖ: İç ortam ortalama sıcaklık değeri ALARM AYARLARI sayfasında belirtilen maksimum sıcaklık değerinin'
    ' "Alarm Gecikmesi" parametresinde belirtilen süre kadar üstüne çıkardsa bu alarm aktif olur.\n\nÇÖZÜM: Sistemde arızalı bir unsur olup'
    ' olmadığı veya kontrol parametrelerinin doğru girilip girilmediği kontrol edilmelidir.' : null;
    kod=="alarminfo14" ? metin='DURUM: İç ortam ortalama nem değeri ALARM AYARLARI sayfasında belirtilen minimum nem değerinin'
    ' "Alarm Gecikmesi" parametresinde belirtilen süre kadar altında kalırsa bu alarm aktif olur.\n\nÇÖZÜM: Sistemde arızalı bir unsur olup'
    ' olmadığı veya kontrol parametrelerinin doğru girilip girilmediği kontrol edilmelidir.' : null;
    kod=="alarminfo15" ? metin='DURUM: İç ortam ortalama nem değeri ALARM AYARLARI sayfasında belirtilen maksimum nem değerinin'
    ' "Alarm Gecikmesi" parametresinde belirtilen süre kadar altında kalırsa bu alarm aktif olur.\n\nÇÖZÜM: Sistemde arızalı bir unsur olup'
    ' olmadığı veya kontrol parametrelerinin doğru girilip girilmediği kontrol edilmelidir.' : null;
    kod=="alarminfo16" ? metin='DURUM: Sensör 1\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo17" ? metin='DURUM: Sensör 2\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo18" ? metin='DURUM: Sensör 3\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo19" ? metin='DURUM: Sensör 4\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo20" ? metin='DURUM: Sensör 5\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo21" ? metin='DURUM: Sensör 6\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo22" ? metin='DURUM: Sensör 7\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo23" ? metin='DURUM: Sensör 8\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo24" ? metin='DURUM: Sensör 9\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo25" ? metin='DURUM: Sensör 10\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo26" ? metin='DURUM: Sensör 11\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo27" ? metin='DURUM: Sensör 12\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo28" ? metin='DURUM: Sensör 13\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo29" ? metin='DURUM: Sensör 14\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo30" ? metin='DURUM: Sensör 15\'de okuma veya bağlantı arızası olduğunda bu alarm aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo31" ? metin='DURUM: İç ortam nem sensöründe okuma veya bağlantı arızası olduğunda bu alarm aktif olur.'
    'ÇÖZÜM:\n'
    ' -0-10V veya 4-20mA analog sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC 0-10V veya 4-20mA analog modül arızası olabilir\n' : null;
    kod=="alarminfo32" ? metin='DURUM: Sistemde ilave edilen ve tanımlamaları "ALARM AYARLARI" sayfasında ekstra alarmlar, sinyalleri PLC\'nin harici alarm girişine'
    ' pozitif sinyal gönderdiğinde bu alarm aktif olur.\n\nÇÖZÜM: Alarmı meydana getiren ilgili durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo33" ? metin='DURUM: Sayac 1\'in bağlı olduğu tüneldeki su tüketimi "ALARM AYARLARI" sayfasındaki "Günlük Min. Tük.(Lt)" parametresinde'
    ' belirtilen tüketim miktarının altında kaldığında bu alarm aktif olur.\n\nÇÖZÜM: Su hattı ve hayvanların sağlık durumu kontrol edilmelidir. Bu alarm'
    ' "YARDIMCI OPSİYONLAR" sayfasındaki "Günlük Su Sayac Verileri Reset Zamanı" parametresinde belirtilen saatte tüketimleri kontrol eder ve aktif olur.' : null;
    kod=="alarminfo34" ? metin='DURUM: Sayac 2\'in bağlı olduğu tüneldeki su tüketimi "ALARM AYARLARI" sayfasındaki "Günlük Min. Tük.(Lt)" parametresinde'
    ' belirtilen tüketim miktarının altında kaldığında bu alarm aktif olur.\n\nÇÖZÜM: Su hattı ve hayvanların sağlık durumu kontrol edilmelidir. Bu alarm'
    ' "YARDIMCI OPSİYONLAR" sayfasındaki "Günlük Su Sayac Verileri Reset Zamanı" parametresinde belirtilen saatte tüketimleri kontrol eder ve aktif olur.' : null;
    kod=="alarminfo35" ? metin='DURUM: Sayac 3\'in bağlı olduğu tüneldeki su tüketimi "ALARM AYARLARI" sayfasındaki "Günlük Min. Tük.(Lt)" parametresinde'
    ' belirtilen tüketim miktarının altında kaldığında bu alarm aktif olur.\n\nÇÖZÜM: Su hattı ve hayvanların sağlık durumu kontrol edilmelidir. Bu alarm'
    ' "YARDIMCI OPSİYONLAR" sayfasındaki "Günlük Su Sayac Verileri Reset Zamanı" parametresinde belirtilen saatte tüketimleri kontrol eder ve aktif olur.' : null;
    kod=="alarminfo36" ? metin='DURUM: Sayac 4\'in bağlı olduğu tüneldeki su tüketimi "ALARM AYARLARI" sayfasındaki "Günlük Min. Tük.(Lt)" parametresinde'
    ' belirtilen tüketim miktarının altında kaldığında bu alarm aktif olur.\n\nÇÖZÜM: Su hattı ve hayvanların sağlık durumu kontrol edilmelidir. Bu alarm'
    ' "YARDIMCI OPSİYONLAR" sayfasındaki "Günlük Su Sayac Verileri Reset Zamanı" parametresinde belirtilen saatte tüketimleri kontrol eder ve aktif olur.' : null;
    kod=="alarminfo37" ? metin='DURUM: Sayac 5\'in bağlı olduğu tüneldeki su tüketimi "ALARM AYARLARI" sayfasındaki "Günlük Min. Tük.(Lt)" parametresinde'
    ' belirtilen tüketim miktarının altında kaldığında bu alarm aktif olur.\n\nÇÖZÜM: Su hattı ve hayvanların sağlık durumu kontrol edilmelidir. Bu alarm'
    ' "YARDIMCI OPSİYONLAR" sayfasındaki "Günlük Su Sayac Verileri Reset Zamanı" parametresinde belirtilen saatte tüketimleri kontrol eder ve aktif olur.' : null;
    kod=="alarminfo38" ? metin='DURUM: Sayac 6\'in bağlı olduğu tüneldeki su tüketimi "ALARM AYARLARI" sayfasındaki "Günlük Min. Tük.(Lt)" parametresinde'
    ' belirtilen tüketim miktarının altında kaldığında bu alarm aktif olur.\n\nÇÖZÜM: Su hattı ve hayvanların sağlık durumu kontrol edilmelidir. Bu alarm'
    ' "YARDIMCI OPSİYONLAR" sayfasındaki "Günlük Su Sayac Verileri Reset Zamanı" parametresinde belirtilen saatte tüketimleri kontrol eder ve aktif olur.' : null;
    kod=="alarminfo39" ? metin='DURUM: Sayac 7\'in bağlı olduğu tüneldeki su tüketimi "ALARM AYARLARI" sayfasındaki "Günlük Min. Tük.(Lt)" parametresinde'
    ' belirtilen tüketim miktarının altında kaldığında bu alarm aktif olur.\n\nÇÖZÜM: Su hattı ve hayvanların sağlık durumu kontrol edilmelidir. Bu alarm'
    ' "YARDIMCI OPSİYONLAR" sayfasındaki "Günlük Su Sayac Verileri Reset Zamanı" parametresinde belirtilen saatte tüketimleri kontrol eder ve aktif olur.' : null;
    kod=="alarminfo40" ? metin='DURUM: Sayac 8\'in bağlı olduğu tüneldeki su tüketimi "ALARM AYARLARI" sayfasındaki "Günlük Min. Tük.(Lt)" parametresinde'
    ' belirtilen tüketim miktarının altında kaldığında bu alarm aktif olur.\n\nÇÖZÜM: Su hattı ve hayvanların sağlık durumu kontrol edilmelidir. Bu alarm'
    ' "YARDIMCI OPSİYONLAR" sayfasındaki "Günlük Su Sayac Verileri Reset Zamanı" parametresinde belirtilen saatte tüketimleri kontrol eder ve aktif olur.' : null;
    kod=="alarminfo41" ? metin='DURUM: Sayac 9\'in bağlı olduğu tüneldeki su tüketimi "ALARM AYARLARI" sayfasındaki "Günlük Min. Tük.(Lt)" parametresinde'
    ' belirtilen tüketim miktarının altında kaldığında bu alarm aktif olur.\n\nÇÖZÜM: Su hattı ve hayvanların sağlık durumu kontrol edilmelidir. Bu alarm'
    ' "YARDIMCI OPSİYONLAR" sayfasındaki "Günlük Su Sayac Verileri Reset Zamanı" parametresinde belirtilen saatte tüketimleri kontrol eder ve aktif olur.' : null;
    kod=="alarminfo42" ? metin='DURUM: Sayac 10\'in bağlı olduğu tüneldeki su tüketimi "ALARM AYARLARI" sayfasındaki "Günlük Min. Tük.(Lt)" parametresinde'
    ' belirtilen tüketim miktarının altında kaldığında bu alarm aktif olur.\n\nÇÖZÜM Su hattı ve hayvanların sağlık durumu kontrol edilmelidir. Bu alarm'
    ' "YARDIMCI OPSİYONLAR" sayfasındaki "Günlük Su Sayac Verileri Reset Zamanı" parametresinde belirtilen saatte tüketimleri kontrol eder ve aktif olur.' : null;
    kod=="alarminfo43" ? metin='DURUM: Sayac 11\'in bağlı olduğu tüneldeki su tüketimi "ALARM AYARLARI" sayfasındaki "Günlük Min. Tük.(Lt)" parametresinde'
    ' belirtilen tüketim miktarının altında kaldığında bu alarm aktif olur.\n\nÇÖZÜM: Su hattı ve hayvanların sağlık durumu kontrol edilmelidir. Bu alarm'
    ' "YARDIMCI OPSİYONLAR" sayfasındaki "Günlük Su Sayac Verileri Reset Zamanı" parametresinde belirtilen saatte tüketimleri kontrol eder ve aktif olur.' : null;
    kod=="alarminfo44" ? metin='DURUM: Sayac 12\'in bağlı olduğu tüneldeki su tüketimi "ALARM AYARLARI" sayfasındaki "Günlük Min. Tük.(Lt)" parametresinde'
    ' belirtilen tüketim miktarının altında kaldığında bu alarm aktif olur.\n\nÇÖZÜM: Su hattı ve hayvanların sağlık durumu kontrol edilmelidir. Bu alarm'
    ' "YARDIMCI OPSİYONLAR" sayfasındaki "Günlük Su Sayac Verileri Reset Zamanı" parametresinde belirtilen saatte tüketimleri kontrol eder ve aktif olur.' : null;
    kod=="alarminfo45" ? metin='DURUM: Sistemi kontrol eden sıcaklık sensörlerinin haricinde doğrudan Server PC\'ye bağlı emniyet sıcaklık sensörünün değeri'
    ' "ALARM & UYARI AYARLARI" sayfasından girilen üst limit değerinin üstüne çıkınca bu alarm aktif olur. Kontrol sisteminin çalışmadığı durumlarda'
    ' ek önlem için kümes içi sıcaklığı devamlı kontrol eder. Bu alarm aktif olduğunda kontrol sistemi, sıcaklık sensörü veya bağlantı kabloları'
    ' kontrol edilmelidir.' : null;
    kod=="alarminfo46" ? metin='DURUM: Pano içinde sıcaklık seviyesi "ALARM & UYARI AYARLARI" sayfasında girilen üst limitin üstüne çıkınca bu alarm'
    ' aktif olur. Pano içini soğutan fanlar, pano iç sıcaklığını artıran arızalı bir ürün olup olmadığı veya bağlantı kabloları kontrol edilmelidir.' : null;


    kod=="alarminfo61" ? metin='DURUM: Dış ortam nem sensöründe okuma veya bağlantı arızası olduğunda bu uyarı aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' -0-10V veya 4-20mA analog sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC 0-10V veya 4-20mA analog modül arızası olabilir\n' : null;
    kod=="alarminfo62" ? metin='DURUM: Dış ortam sıcaklık sensöründe okuma veya bağlantı arızası olduğunda bu uyarı aktif olur.\n\n'
    'ÇÖZÜM:\n'
    ' Sensör tipi analog sensör ise :\n'
    ' -PT100 sensörün kendisi arızalanmış olabilir\n'
    ' -Kablo ve klemens bağlantılarında temassızlık olabilir\n'
    ' -PLC PT100 analog modül arızası olabilir\n\n'
    ' Sensör tipi wifi sensör ise :\n'
    ' -Wifi sensörün, sensör kısmı arızalanmış olabilir\n'
    ' -Wifi sensörün, wifi bağlantı kısmı arızalanmış olabilir\n'
    ' -Server PC\'deki wifi sensör kontrol yazılımı kapanmış olabilir\n'
    ' -Wifi ağını yapan modem ve menzil genişletici cihazlar arızalanmış olabilir\n\n'
    ' tüm bu durumlar kontrol edilmelidir.' : null;
    kod=="alarminfo63" ? metin='DURUM: Rutin ped bakım zamanı gediğinde bu uyarı aktif olur.\n\nÇÖZÜM: Gerekli bakımlar yapıldıktan sonra uyarı resetlendiğinde'
    ' bakım döngüsü bir sonraki bakım zamanı tekrar uyarmak üzere resetlenir.' : null;
    kod=="alarminfo64" ? metin='DURUM: Rutin sistem bakım zamanı gediğinde bu uyarı aktif olur.\n\nÇÖZÜM: Gerekli bakımlar yapıldıktan sonra uyarı resetlendiğinde'
    ' bakım döngüsü bir sonraki bakım zamanı tekrar uyarmak üzere resetlenir.' : null;

    kod=="baglantiinfo1" ? metin='DURUM: Ekran ile ağ arasındaki bağlantı koptuğu zaman bu hata aktif olur.\n\n'
    'ÇÖZÜM: Ekran ile ağ arasındaki bağlantı kabloları veya bağlı bulundupu switch portu kontrol edilmelidir. ' : null;
    
    kod=="baglantiinfo2" ? metin='DURUM: Ekran ile server PC arasındaki iletişim taleplerine 5sn\'den fazla yanıt gelmezse bu hata aktif olur.\n\n'
    'ÇÖZÜM: Server PC\'nin arızalı olup olmadığı, enerjisi olup olmadığı, ağa bağlı olup olmadığı kontrol edilmelidir. ' : null;

    kod=="baglantiinfo3" ? metin='DURUM: Tüm unsurlar ağa sorunsuz bağlı iken server PC içerisindeki bilgi akışını sağlayan ilgili port'
    ' açık değilse bu hata meydana gelir\n\n'
    'ÇÖZÜM: Server PC\'nin enerjisinin kesilip tekrar açılarak resetlenmesi gerekmektedir.' : null;

    kod=="baglantiinfo4" ? metin='DURUM: PLC ile ağ arasındaki bağlantının koptuğu, PLC\'nin enerjisinin kesildiği ve ekranın PLC\'ye bu nedenlerle'
    ' erişemediği durumlarda bu hata aktif olur.\n\n'
    'ÇÖZÜM: PLC\'nin enerjisinin olup olmadığı, PLC ile ağ arasındaki bağlantı kablolarında sorun olup olmadığı veya bağlı bulundupu switch portu kontrol edilmelidir' : null;

    kod=="baglantiinfo5" ? metin='DURUM: Bağlantı sisteminde tanımsız diğer hatalardan biri meydana geldiğinde bu hata aktif olur.\n\n'
    'ÇÖZÜM:\n'
    'No route to host : Modem veya switch işlevsiz hale geldiğinde veya bunlarla ekran bağlantısı kesildiğinde bu alarm meydana gelebilir. Modem, switch ve bağlantılar'
    ' kontrol edilmelidir.\n\n'
    'Software caused connection abort: Modem veya switch işlevsiz hale geldiğinde veya bunlarla ekran bağlantısı kesildiğinde ekran yazılımı bağlantıyı kopardığından'
    ' bu alam meydana gelebilir. Modem, switch ve bağlantılar kontrol edilmelidir.' : null;
 



    //KISALTMALAR
    kod=='ksltm1' ? metin='SIC.SEN. → SICAKLIK SENSÖRLERİ' : null;
    kod=='ksltm2' ? metin='B.FANI → BACAFANI' : null;
    kod=='ksltm3' ? metin='SİRK.FANI → SİRKÜLASYON FANI' : null;
    kod=='ksltm4' ? metin='AYD. → AYDINLATMA' : null;
    kod=='ksltm5' ? metin='S.SAYACI → SU SAYACI' : null;
    kod=='ksltm6' ? metin='Ort.Hissed.Sıc. → Ortalama Hissedilir Sıcaklık' : null;
    kod=='ksltm7' ? metin='Doğ.B.Bitiş → Doğal Bölge Bitiş' : null;
    kod=='ksltm8' ? metin='Çap.B.Bitiş → Çapraz Bölge Bitiş' : null;
    kod=='ksltm9' ? metin='Ölç.Max.OSıc → Ölçülen Maximum Ortalama Sıcaklık' : null;
    kod=='ksltm10' ? metin='Ölç.Min.OSıc → Ölçülen Minimum Ortalama Sıcaklık' : null;
    kod=='ksltm11' ? metin='Ölç.Max.Nem → Ölçülen Maximum Nem' : null;
    kod=='ksltm12' ? metin='Ölç.Min.Nem → Ölçülen Minimum Nem' : null;
    kod=='ksltm13' ? metin='Max.OSic.Saati → Maximum Ortalama Sıcaklık Saati' : null;
    kod=='ksltm14' ? metin='Min.OSic.Saati → Minimum Ortalama Sıcaklık Saati' : null;
    kod=='ksltm15' ? metin='Max.Nem Saati → Maximum Nem Saati' : null;
    kod=='ksltm16' ? metin='Min.Nem Saati → Minimum Nem Saati' : null;
    kod=='ksltm17' ? metin='SIC. & FAN → SICAKLIKLAR & FAN' : null;
    kod=='ksltm18' ? metin='MİN. HAV. → MİNİMUM HAVALANDIRMA' : null;
    kod=='ksltm19' ? metin='YARD. OPS. → YARDIMCI OPSİYONLAR' : null;
    kod=='ksltm20' ? metin='T.FAN → TÜNEL FAN' : null;
    kod=='ksltm21' ? metin='Set Sıc → Set Sıcaklığı' : null;
    kod=='ksltm22' ? metin='Ort Sıc → Ortalama Sıcaklık' : null;
    kod=='ksltm23' ? metin='K1-K2....K10 → KLEPE1-KLEPE2.....KLEPE10' : null;
    kod=='ksltm24' ? metin='S1-S2....S10 → SENSÖR1-SENSÖR2.....SENSÖR10' : null;
    kod=='ksltm25' ? metin='OTO → OTOMATİK' : null;
    kod=='ksltm26' ? metin='MAN → MANUEL' : null;
    kod=='ksltm27' ? metin='Çkş1 → Çıkış1' : null;
    kod=='ksltm28' ? metin='Çkş2 → Çıkış2' : null;
    kod=='ksltm29' ? metin='Çkş3 → Çıkış3' : null;
    kod=='ksltm30' ? metin='Günlük Toplam Tük(Kg) → Günlük Toplam Tüketim(Kg)' : null;
    kod=='ksltm31' ? metin='Günlük Hay.Baş.Tük(Gr) → Günlük Hayvan Başına Tüketim(Gr)' : null;
    kod=='ksltm32' ? metin='Günlük Topl.Tük → Günlük Toplam Tüketim' : null;
    kod=='ksltm33' ? metin='Günlük Hay.Baş → Günlük Hayvan Başına Tüketim' : null;
    kod=='ksltm34' ? metin='S1 → SİLO1' : null;
    kod=='ksltm35' ? metin='S2 → SİLO2' : null;
    kod=='ksltm36' ? metin='S3 → SİLO3' : null;
    kod=='ksltm37' ? metin='S4 → SİLO4' : null;
    kod=='ksltm38' ? metin='Klp Baş. Düş. Fan Mik.\n→ Klepe Başına Düşen Fan Miktarı' : null;
    kod=='ksltm39' ? metin='Klp Baş. Düş. Fan M.Modu\n→ Klepe Başına Düşen Fan Miktarı Modu' : null;
    kod=='ksltm40' ? metin='Min.-Max. Açıklık\n→ Minimum-Maximum Açıklık' : null;
    kod=='ksltm41' ? metin='Min.-Hav. Açıklık\n→ Minimum Havalandırma Açıklık' : null;



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
    kod=="tv15" ? metin='Temp.S.Number' : null;
    kod=="tv16" ? metin='Chim. Fan?' : null;
    kod=="tv17" ? metin='A.Inlet & Sirc. Fan' : null;
    kod=="tv18" ? metin='Heater Number' : null;
    kod=="tv19" ? metin='Silo Count' : null;
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
    kod=="tv49" ? metin='TEMP. Sensor No' : null;
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
    kod=="tv61" ? metin='TEMP. Sensor NO Sign' : null;
    kod=="tv62" ? metin='OUTPUTS' : null;
    kod=="tv63" ? metin='Gr:' : null;
    kod=="tv64" ? metin='Cfan No' : null;
    kod=="tv65" ? metin='C.Fan Gr-1 Out No' : null;
    kod=="tv66" ? metin='Digital\nOutput' : null;
    kod=="tv67" ? metin='Analog\nOutput' : null;
    kod=="tv68" ? metin='Chimney Fan Map' : null;
    kod=="tv69" ? metin='Cfan Group Out No' : null;
    kod=="tv70" ? metin='Out Temp. Sen.' : null;
    kod=="tv71" ? metin='Air Inlet & Sirc. Fan' : null;
    kod=="tv72" ? metin='No:' : null;
    kod=="tv73" ? metin='Out:' : null;
    kod=="tv74" ? metin='A.INLET NO' : null;
    kod=="tv75" ? metin='Air:' : null;
    kod=="tv76" ? metin='Heater Map' : null;
    kod=="tv77" ? metin='Heater Gr-1 Out No' : null;
    kod=="tv78" ? metin='Heater Gr-2 Out No' : null;
    kod=="tv79" ? metin='Heater Gr-3 Out No' : null;
    kod=="tv80" ? metin='Heater Group No' : null;
    kod=="tv81" ? metin='Auto-Man Details' : null;
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
    kod=="tv99" ? metin='GENERAL SETTINGS' : null;
    kod=="tv100" ? metin='WATCH' : null;
    kod=="tv101" ? metin='AUTO-MAN' : null;
    kod=="tv102" ? metin='CONTROL' : null;
    kod=="tv103" ? metin='LOG&CHART' : null;
    kod=="tv104" ? metin='ALARM/WARN' : null;
    kod=="tv105" ? metin='SYSTEM' : null;
    kod=="tv106" ? metin='CONTROL SETTINGS' : null;
    kod=="tv107" ? metin='TEMP. & HUM.' : null;
    kod=="tv108" ? metin='FLAP' : null;
    kod=="tv109" ? metin='COOL. & HUM.' : null;
    kod=="tv110" ? metin='MIN. VENT.' : null;
    kod=="tv111" ? metin='OTHER OPT.' : null;
    kod=="tv112" ? metin='LIGHTING' : null;
    kod=="tv113" ? metin='FEEDING' : null;
    kod=="tv114" ? metin='HELPER OPT.' : null;
    kod=="tv115" ? metin='Set temperature' : null;
    kod=="tv116" ? metin='Natural Zone finish temp.' : null;
    kod=="tv117" ? metin='Cross vent. finish temp.' : null;
    kod=="tv118" ? metin='Tunnel vent. active area' : null;
    kod=="tv119" ? metin='Cross vent. active area' : null;
    kod=="tv120" ? metin='Nat.Zone-Min.Vent Cont.' : null;
    kod=="tv121" ? metin='Min.Vent. Intermittent' : null;
    kod=="tv122" ? metin='Max. fan temperature' : null;
    kod=="tv123" ? metin='Temperature Diagram' : null;
    kod=="tv124" ? metin='Navigator Menu' : null;
    kod=="tv125" ? metin='Set Temperature (A)' : null;
    kod=="tv126" ? metin='Naturel Zone Difference (B)' : null;
    kod=="tv127" ? metin='FANS OF SET TEMPERATURE (°C)' : null;
    kod=="tv128" ? metin='Cross Vent. Difference (C)' : null;
    kod=="tv129" ? metin='Silo No' : null;
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
    kod=="tv180" ? metin='DEFINITION OF SET TEMPERATURES FOR 7 WEEKLY ' : null;
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
    kod=="tv194" ? metin='Aktuel Interval (%) :' : null;
    kod=="tv195" ? metin='Working Fan 1-2 :' : null;
    kod=="tv196" ? metin='Flap Interval 1-2 :' : null;
    kod=="tv197" ? metin='Working Fan 3-4 :' : null;
    kod=="tv198" ? metin='Flap Interval 3-4 :' : null;
    kod=="tv199" ? metin='Min.Vent. Interval (%) :' : null;
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
    kod=="tv216" ? metin='Min-Max. Interval (%) :' : null;
    kod=="tv217" ? metin='Fan Number per\nFlp for Man:' : null;
    kod=="tv217a" ? metin='Fan Number per Flp for Man:' : null;
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
    kod=="tv232" ? metin='Start\nCalibration' : null;
    kod=="tv232a" ? metin='Start Calibration' : null;
    kod=="tv233" ? metin='Calibration State :' : null;
    kod=="tv234" ? metin='Calibration Time :' : null;
    kod=="tv235" ? metin='Flp Auto-Man State :' : null;
    kod=="tv236" ? metin='Active' : null;
    kod=="tv237" ? metin='Passive' : null;
    kod=="tv238" ? metin='Sec' : null;
    kod=="tv239" ? metin='FLAP CALIBRATION' : null;
    kod=="tv240" ? metin='Sensor Calibration Details' : null;
    kod=="tv241" ? metin='Flap\nCalibration' : null;
    kod=="tv242" ? metin='Start Temperature :' : null;
    kod=="tv243" ? metin='Stop Temperature :' : null;
    kod=="tv244" ? metin='PED P.' : null;
    kod=="tv245" ? metin='START TEMPERATURE DIFF.' : null;
    kod=="tv246" ? metin='STOP TEMPERATURE DIFF.' : null;
    kod=="tv247" ? metin='Start Temp. Diff.' : null;
    kod=="tv248" ? metin='Stop Temp. Diff.' : null;
    kod=="tv249" ? metin='COOLING AND HUMIDITY' : null;
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
    kod=="tv272" ? metin='Max. Start Time\nin Intermittent' : null;
    kod=="tv272a" ? metin='Max. Start Time in Intermittent' : null;
    kod=="tv273" ? metin='Air Inlet\nPriority Time(Sec)' : null;
    kod=="tv273a" ? metin='Air Inlet Priority Time(Sec)' : null;
    kod=="tv274" ? metin='Air Inlet\nPercent(%)' : null;
    kod=="tv274a" ? metin='Air Inlet Percent(%)' : null;
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
    kod=="tv289" ? metin='Tunnel Fan KW' : null;
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
    kod=="tv303" ? metin='Fan Control Method' : null;
    kod=="tv304" ? metin='MV Control Method' : null;
    kod=="tv305" ? metin='Flap Motor KW' : null;
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
    kod=="tv333a" ? metin='On-Off Time 2 Activity' : null;
    kod=="tv334" ? metin='Dimmer' : null;
    kod=="tv335" ? metin='Daytime bright Percent' : null;
    kod=="tv336" ? metin='Nighttime bright Percent' : null;
    kod=="tv337" ? metin='Sunrise-Sunset\nTime (Sec)' : null;
    kod=="tv337a" ? metin='Sunrise-Sunset Time (Sec)' : null;
    kod=="tv338" ? metin='Hour' : null;
    kod=="tv339" ? metin='Minute' : null;
    kod=="tv340" ? metin='Light Percent(%)' : null;
    kod=="tv341" ? metin='Instant Light Percent(%)' : null;
    kod=="tv342" ? metin='Ped Pump KW' : null;
    kod=="tv343" ? metin='Daytime Percent 1' : null;
    kod=="tv344" ? metin='Daytime Percent 2' : null;
    kod=="tv345" ? metin='Nighttime Percent 1' : null;
    kod=="tv346" ? metin='Nighttime Percent 2' : null;
    kod=="tv347" ? metin='HERD' : null;
    kod=="tv348" ? metin='CALIBRATION' : null;
    kod=="tv349" ? metin='Inputs' : null;
    kod=="tv350" ? metin='Chim. Motors KW' : null;
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
    kod=="tv383" ? metin='C.Fan Fuse' : null;
    kod=="tv384" ? metin='Heater Fuse' : null;
    kod=="tv385" ? metin='Sirc. Fuse' : null;
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
    kod=="tv407" ? metin='TIME ZONE' : null;
    kod=="tv408" ? metin='MINUTE' : null;
    kod=="tv409" ? metin='Hour Format\n00:00-23:59' : null;
    kod=="tv410" ? metin='Date Format 1\nDD-MM-YYYY' : null;
    kod=="tv411" ? metin='Date Format 1\nMM-DD-YYYY' : null;
    kod=="tv412" ? metin='CONFIRM TIME' : null;
    kod=="tv413" ? metin='CONFIRM DATE' : null;
    kod=="tv414" ? metin='HERD INFORMATIONS' : null;
    kod=="tv415" ? metin='Herd Birth\nDate' : null;
    kod=="tv415a" ? metin='Herd Birth Date' : null;
    kod=="tv416" ? metin='Herd Enter\nTime' : null;
    kod=="tv416a" ? metin='Herd Enter Time' : null;
    kod=="tv417" ? metin='Count of Animals\n(at enterance)' : null;
    kod=="tv417a" ? metin='Count of Animals (at enterance)' : null;
    kod=="tv418" ? metin='Count of Death\n' : null;
    kod=="tv419" ? metin='Entering Number of Death Animals According to Categories' : null;
    kod=="tv420" ? metin='Disease Related' : null;
    kod=="tv421" ? metin='Equipment Related' : null;
    kod=="tv422" ? metin='Animal Attact Related' : null;
    kod=="tv423" ? metin='Ventilation Related' : null;
    kod=="tv424" ? metin='Feed Related' : null;
    kod=="tv425" ? metin='Water Related' : null;
    kod=="tv426" ? metin='Death\nRate (%)' : null;
    kod=="tv427" ? metin='Actual Number\nof Animals' : null;
    kod=="tv428" ? metin='Herd Age\n(Daily)' : null;
    kod=="tv429" ? metin='Herd Age\n(Weekly)' : null;
    kod=="tv430" ? metin='External Alarm' : null;
    kod=="tv431" ? metin='SENSOR CALIBRATION' : null;
    kod=="tv432" ? metin='Hum. Sen. Measure Method' : null;
    kod=="tv433" ? metin='Wifi' : null;
    kod=="tv434" ? metin='Analog' : null;
    kod=="tv435" ? metin='Temperature Sensors' : null;
    kod=="tv436" ? metin='Enter Positive-Negative Sensor Calibration Value' : null;
    kod=="tv437" ? metin='Temperature\nValue (°C)' : null;
    kod=="tv438" ? metin='+ Value' : null;
    kod=="tv439" ? metin='- Value' : null;
    kod=="tv440" ? metin='Hum. Sensors' : null;
    kod=="tv441" ? metin='Inside Hum.' : null;
    kod=="tv441a" ? metin='Inside\nHum.' : null;
    kod=="tv442" ? metin='Outside Hum.' : null;
    kod=="tv443" ? metin='Analog1' : null;
    kod=="tv444" ? metin='Analog2' : null;
    kod=="tv445" ? metin='Analog3' : null;
    kod=="tv446" ? metin='Analog4' : null;
    kod=="tv447" ? metin='Analog5' : null;
    kod=="tv448" ? metin='Analog6' : null;
    kod=="tv449" ? metin='Analog7' : null;
    kod=="tv450" ? metin='Analog8' : null;
    kod=="tv451" ? metin='Analog9' : null;
    kod=="tv452" ? metin='Analog10' : null;
    kod=="tv453" ? metin='Sensor Calibration Details' : null;
    kod=="tv454" ? metin='AUTO-MAN SELECTION' : null;
    kod=="tv455" ? metin='AUTO' : null;
    kod=="tv456" ? metin='MAN' : null;
    kod=="tv457" ? metin='MAN Control' : null;
    kod=="tv458" ? metin='T.FAN' : null;
    kod=="tv459" ? metin='PED PUMP' : null;
    kod=="tv460" ? metin='AIR INLET' : null;
    kod=="tv461" ? metin='CHIMNEY FAN' : null;
    kod=="tv462" ? metin='HEATER' : null;
    kod=="tv463" ? metin='FEED CAR' : null;
    kod=="tv464" ? metin='MANUAL CONTROL OF TUNNEL FANS' : null;
    kod=="tv465" ? metin='MANUAL CONTROL OF PED PUMPS' : null;
    kod=="tv466" ? metin='MANUAL CONTROL OF LIGHTING SYSTEM' : null;
    kod=="tv467" ? metin='MANUAL CONTROL OF CHIMNEY FANS' : null;
    kod=="tv468" ? metin='MANUAL CONTROL OF HEATERS' : null;
    kod=="tv469" ? metin='MANUAL CONTROL OF FEED CARS' : null;
    kod=="tv470" ? metin='Manual Lighting Percent (%)' : null;
    kod=="tv471" ? metin='MANUAL CONTROL' : null;
    kod=="tv472" ? metin='Flap Step Time (Sec)' : null;
    kod=="tv473" ? metin='OPEN' : null;
    kod=="tv474" ? metin='CLOSE' : null;
    kod=="tv475" ? metin='FLAP AUTO-MAN SELECTION' : null;
    kod=="tv476" ? metin='AIR INLET AUTO-MAN SELECTION' : null;
    kod=="tv477" ? metin='Air Inlet Step Time (Sec)' : null;
    kod=="tv478" ? metin='How Many Days to Perform\nMin.Vent After the Start?' : null;
    kod=="tv478a" ? metin='How Many Days to Perform Min.Vent After the Start?' : null;
    kod=="tv479" ? metin='Only Min. Vent\nMode Active' : null;
    kod=="tv479a" ? metin='Only Min. Vent Mode Active' : null;
    kod=="tv480" ? metin='Keep Flow in transition\nto Min. Vent?' : null;
    kod=="tv480a" ? metin='Keep Flow in transition to Min. Vent?' : null;
    kod=="tv481" ? metin='HELPER OPTIONS' : null;
    kod=="tv482" ? metin='Min. Hum (%)' : null;
    kod=="tv483" ? metin='Temperature-Interval Diagram' : null;
    kod=="tv484" ? metin='Minimum Hum.' : null;
    kod=="tv485" ? metin='At Low Hum.\nPed Pumps Run' : null;
    kod=="tv485a" ? metin='At Low Hum. Ped Pumps Run' : null;
    kod=="tv486" ? metin='Temp. Priority' : null;
    kod=="tv487" ? metin='Ped P. 1' : null;
    kod=="tv488" ? metin='Ped P. 2-3' : null;
    kod=="tv489" ? metin='At High Hum.\nAll Fans Run' : null;
    kod=="tv489a" ? metin='At High Hum. All Fans Run' : null;
    kod=="tv490" ? metin='Out Hum\nHigh Limit Active' : null;
    kod=="tv491" ? metin='Out Hum\nHigh Limit' : null;
    kod=="tv492" ? metin='0-10V' : null;
    kod=="tv493" ? metin='4-20mA' : null;
    kod=="tv494" ? metin='Chimney F.\nMotor Speed (Hz)' : null;
    kod=="tv495" ? metin='Chimney Fans' : null;
    kod=="tv496" ? metin='OPTION 1' : null;
    kod=="tv497" ? metin='OPTION 2' : null;
    kod=="tv498" ? metin='Flap Control According\nto Nearby Temp. Sensor' : null;
    kod=="tv499" ? metin='ENTER SETTINGS' : null;
    kod=="tv500" ? metin='SENSOR FLAP CONTROL' : null;
    kod=="tv501" ? metin='Temp. Diff.(°C)' : null;
    kod=="tv502" ? metin='Sens. No1' : null;
    kod=="tv503" ? metin='Sens. No2' : null;
    kod=="tv504" ? metin='Set Temp. - Temp. Diff.' : null;
    kod=="tv505" ? metin='Current Flap Interval' : null;
    kod=="tv506" ? metin='12:00 AM' : null;
    kod=="tv507" ? metin='12:30 AM' : null;
    kod=="tv508" ? metin='01:00 AM' : null;
    kod=="tv509" ? metin='01:30 AM' : null;
    kod=="tv510" ? metin='02:00 AM' : null;
    kod=="tv511" ? metin='02:30 AM' : null;
    kod=="tv512" ? metin='03:00 AM' : null;
    kod=="tv513" ? metin='03:30 AM' : null;
    kod=="tv514" ? metin='04:00 AM' : null;
    kod=="tv515" ? metin='04:30 AM' : null;
    kod=="tv516" ? metin='05:00 AM' : null;
    kod=="tv517" ? metin='05:30 AM' : null;
    kod=="tv518" ? metin='06:00 AM' : null;
    kod=="tv519" ? metin='06:30 AM' : null;
    kod=="tv520" ? metin='07:00 AM' : null;
    kod=="tv521" ? metin='07:30 AM' : null;
    kod=="tv522" ? metin='08:00 AM' : null;
    kod=="tv523" ? metin='08:30 AM' : null;
    kod=="tv524" ? metin='09:00 AM' : null;
    kod=="tv525" ? metin='09:30 AM' : null;
    kod=="tv526" ? metin='10:00 AM' : null;
    kod=="tv527" ? metin='10:30 AM' : null;
    kod=="tv528" ? metin='11:00 AM' : null;
    kod=="tv529" ? metin='11:30 AM' : null;
    kod=="tv530" ? metin='12:00 PM' : null;
    kod=="tv531" ? metin='12:30 PM' : null;
    kod=="tv532" ? metin='01:00 PM' : null;
    kod=="tv533" ? metin='01:30 PM' : null;
    kod=="tv534" ? metin='02:00 PM' : null;
    kod=="tv535" ? metin='02:30 PM' : null;
    kod=="tv536" ? metin='03:00 PM' : null;
    kod=="tv537" ? metin='03:30 PM' : null;
    kod=="tv538" ? metin='04:00 PM' : null;
    kod=="tv539" ? metin='04:30 PM' : null;
    kod=="tv540" ? metin='05:00 PM' : null;
    kod=="tv541" ? metin='05:30 PM' : null;
    kod=="tv542" ? metin='06:00 PM' : null;
    kod=="tv543" ? metin='06:30 PM' : null;
    kod=="tv544" ? metin='07:00 PM' : null;
    kod=="tv545" ? metin='07:30 PM' : null;
    kod=="tv546" ? metin='08:00 PM' : null;
    kod=="tv547" ? metin='08:30 PM' : null;
    kod=="tv548" ? metin='09:00 PM' : null;
    kod=="tv549" ? metin='09:30 PM' : null;
    kod=="tv550" ? metin='10:00 PM' : null;
    kod=="tv551" ? metin='10:30 PM' : null;
    kod=="tv552" ? metin='11:00 PM' : null;
    kod=="tv553" ? metin='11:30 PM' : null;
    kod=="tv554" ? metin='FEED OUTPUT 1' : null;
    kod=="tv555" ? metin='FEED OUTPUT 2' : null;
    kod=="tv556" ? metin='FEED OUTPUT 3' : null;
    kod=="tv557" ? metin='Forth' : null;
    kod=="tv558" ? metin='Back' : null;
    kod=="tv559" ? metin='CHOOSING FEEDING TIME' : null;
    kod=="tv560" ? metin='Feeding Details' : null;
    kod=="tv561" ? metin='Signal Time (Sec) : ' : null;
    kod=="tv562" ? metin='Tunnel Fans\'s Minimum Run\nTime after first run in auto mode (Sec)' : null;
    kod=="tv562a" ? metin='Tunnel Fans\'s Minimum Run Time after first run in auto mode (Sec)' : null;
    kod=="tv563" ? metin='You didn\'t approve new password! Do you still want to quit?' : null;
    kod=="tv564" ? metin='You didn\'t send the changes! Do you still want to quit?' : null;
    kod=="tv565" ? metin='OPTION 4' : null;
    kod=="tv566" ? metin='Stop System\nWhen Power off' : null;
    kod=="tv566a" ? metin='Stop System When Power off' : null;
    kod=="tv567" ? metin='T.Fan. Soft\nPassing Cycle' : null;
    kod=="tv567a" ? metin='T.Fan. Soft Passing Cycle' : null;
    kod=="tv568" ? metin='T.Fan. Soft\nPassing Quantity' : null;
    kod=="tv568a" ? metin='T.Fan. Soft Passing Quantity' : null;
    kod=="tv569" ? metin='SYSTEM MONITORING' : null;
    kod=="tv570" ? metin='Tunnel Fans' : null;
    kod=="tv571" ? metin='MODE :' : null;
    kod=="tv572" ? metin='System Off' : null;
    kod=="tv573" ? metin='Min.Vent. Intermittent' : null;
    kod=="tv574" ? metin='Min. Hav. Continuously' : null;
    kod=="tv575" ? metin='Cross Ventilation' : null;
    kod=="tv576" ? metin='Tunnel Ventilation' : null;
    kod=="tv577" ? metin='High Hum.' : null;
    kod=="tv578" ? metin='Low Hum.' : null;
    kod=="tv579" ? metin='On:' : null;
    kod=="tv580" ? metin='Off:' : null;
    kod=="tv581" ? metin='Sirc. Fan' : null;
    kod=="tv582" ? metin='Set\nTem' : null;
    kod=="tv583" ? metin='Avr\nTem' : null;
    kod=="tv584" ? metin='Nat.Z.End' : null;
    kod=="tv585" ? metin='Cro.Z.End' : null;
    kod=="tv586" ? metin='Air Inlet' : null;
    kod=="tv587" ? metin='A.In.1' : null;
    kod=="tv588" ? metin='A.In.2' : null;
    kod=="tv589" ? metin='State' : null;
    kod=="tv590" ? metin='Open' : null;
    kod=="tv591" ? metin='Close' : null;
    kod=="tv592" ? metin='Heater' : null;
    kod=="tv593" ? metin='Gr. 1:' : null;
    kod=="tv594" ? metin='Gr. 2:' : null;
    kod=="tv595" ? metin='Gr. 3:' : null;
    kod=="tv596" ? metin='Openning' : null;
    kod=="tv597" ? metin='Closing:' : null;
    kod=="tv598" ? metin='MONITOR-1' : null;
    kod=="tv599" ? metin='MONITOR-1' : null;
    kod=="tv600" ? metin='S1:' : null;//Silo 1
    kod=="tv601" ? metin='S2:' : null;//Silo 1
    kod=="tv602" ? metin='S3:' : null;//Silo 1
    kod=="tv603" ? metin='S4:' : null;//Silo 1
    kod=="tv604" ? metin='Kg' : null;
    kod=="tv605" ? metin='Daily Tot.\nCons.(Kg)' : null;
    kod=="tv606" ? metin='Daily\nPer Bird\nCons.(Gr)' : null;
    kod=="tv607" ? metin='Next Feed\nTime' : null;
    kod=="tv608" ? metin='Light On-Off\nTime' : null;
    kod=="tv609" ? metin='WATERMETERS' : null;
    kod=="tv610" ? metin='Water Consumptions(Lt)' : null;
    kod=="tv611" ? metin='Daily Tot.Cons:' : null;
    kod=="tv612" ? metin='Daily Per Bird:' : null;
    kod=="tv613" ? metin='Light Per.(%):' : null;
    kod=="tv614" ? metin='Mea.Max.ATemp' : null;
    kod=="tv615" ? metin='Mea.Min.ATemp' : null;
    kod=="tv616" ? metin='Max.ATemp.Time' : null;
    kod=="tv617" ? metin='Min.ATemp.Time' : null;
    kod=="tv618" ? metin='In Hum.' : null;
    kod=="tv619" ? metin='Out Hum.' : null;
    kod=="tv620" ? metin='Avr.Sens.Temp.' : null;
    kod=="tv621" ? metin='Feeding\noutput\nisn\'t active\nin system!' : null;
    kod=="tv622" ? metin='Watermeter\ninputs\nisn\'t active\nin system!' : null;
    kod=="tv623" ? metin='Feed silo Weight\nreadings\nisn\'t active\nin system' : null;
    kod=="tv624" ? metin='Chim.Fan\nShutter\nExist?' : null;
    kod=="tv625" ? metin='Shutter On\nOutput No' : null;
    kod=="tv626" ? metin='Shutter Off\nOutput No' : null;
    kod=="tv627" ? metin='Sirc. Fan\nOutput No' : null;
    kod=="tv628" ? metin='Air Op\nOutput No' : null;
    kod=="tv629" ? metin='Air Cls\nOutput No' : null;
    kod=="tv630" ? metin='Sirc. Fan\n isn\'t active\n in Numbers Page!' : null;
    kod=="tv631" ? metin='Air Inlet\n isn\'t active\n in Numbers Page!' : null;
    kod=="tv632" ? metin='Feed Car\nFuse' : null;
    kod=="tv633" ? metin='Light\nFuse' : null;
    kod=="tv634" ? metin='Fan map loading...' : null;
    kod=="tv635" ? metin='Flap map loading...' : null;
    kod=="tv636" ? metin='Outputs Loading...' : null;
    kod=="tv637" ? metin='Water\nAlarm' : null;
    kod=="tv638" ? metin='Inputs Loading...' : null;
    kod=="tv639" ? metin='FEED SILOS' : null;
    kod=="tv640" ? metin='OFF' : null;
    kod=="tv641" ? metin='FAN - KLEPE' : null;
    kod=="tv642" ? metin='TEMP. SEN - PED' : null;
    kod=="tv643" ? metin='C.FAN - AIR. IN.' : null;
    kod=="tv644" ? metin='SIRC. FAN - HEATER' : null;
    kod=="tv645" ? metin='FEEDING - LIGHT' : null;
    kod=="tv646" ? metin='W.METER - SILO' : null;
    kod=="tv647" ? metin='MONITOR-3' : null;
    kod=="tv648" ? metin='Start Auto Assignment From This Output' : null;
    kod=="tv649" ? metin='CHIMNEY FANS' : null;
    kod=="tv650" ? metin='HEATERS' : null;
    kod=="tv651" ? metin='Motor Speed(Hz): ' : null;
    kod=="tv652" ? metin='RemainingT.(Sn): ' : null;
    kod=="tv653" ? metin='SIRC.FAN' : null;
    kod=="tv654" ? metin='MANUAL CONTROL OF SIRC. FAN' : null;
    kod=="tv655" ? metin='Remain' : null;
    kod=="tv656" ? metin='Air inlet isn\'t active\nin the system' : null;
    kod=="tv657" ? metin='Chimney fan\nisn\'t active\nin the system' : null;
    kod=="tv658" ? metin='Heater\nisn\'t active\nin the system' : null;
    kod=="tv659" ? metin='Feeding\nisn\'t active\nin the system' : null;
    kod=="tv660" ? metin='Sirc. fan\nisn\'t active\nin the system' : null;
    kod=="tv661" ? metin='Average Temprerature' : null;
    kod=="tv661a" ? metin='Average\nTemprerature' : null;
    kod=="tv662" ? metin='Air  Velocity (m/sec)' : null;
    kod=="tv663" ? metin='OPTION 5' : null;
    kod=="tv664" ? metin='KW Values' : null;
    kod=="tv665" ? metin='Max.Meas. Nem' : null;
    kod=="tv666" ? metin='Min.Meas. Nem' : null;
    kod=="tv667" ? metin='Max.Hum Time' : null;
    kod=="tv668" ? metin='Min.Hum Time' : null;
    kod=="tv669" ? metin='OPTION 6' : null;
    kod=="tv670" ? metin='Reset Time for Daily Measured\nMin-Max Temp and Hum Data' : null;
    kod=="tv670a" ? metin='Reset Time for Daily Measured\nMin-Max Temp and Hum Data(Min)' : null;
    kod=="tv670b" ? metin='Reset Time for Daily Measured\nMin-Max Temp and Hum Data(Hour)' : null;
    kod=="tv671" ? metin='OPTION 7' : null;
    kod=="tv672" ? metin='Reset Time for Daily\nFeed, Water and Power Consumption' : null;
    kod=="tv672a" ? metin='Reset Time for Daily\nFeed, Water and Power Consumption(Min)' : null;
    kod=="tv672b" ? metin='Reset Time for Daily\nFeed, Water and Power Consumption(Hour)' : null;
    kod=="tv673" ? metin='ABBREVIATIONS:' : null;
    kod=="tv674" ? metin='Mortality (%)' : null;
    kod=="tv675" ? metin='Actuel Animal Count' : null;
    kod=="tv676" ? metin='OPTION 3' : null;
    kod=="tv677" ? metin='SOFTWARE' : null;
    kod=="tv678" ? metin='Software Definition' : null;
    kod=="tv679" ? metin='Programmable Poultry Air Conditioning System \nLocal Panel HMI Software' : null;
    kod=="tv680" ? metin='Software Name' : null;
    kod=="tv681" ? metin='PROKIS CORE' : null;
    kod=="tv682" ? metin='Version Number' : null;
    kod=="tv683" ? metin='PCV 1.0.0' : null;
    kod=="tv684" ? metin='SYSTEM START-STOP' : null;
    kod=="tv685" ? metin='System Start or Stop' : null;
    kod=="tv686" ? metin='System State' : null;
    kod=="tv687" ? metin='SYSTEM WORKING' : null;
    kod=="tv688" ? metin='SYSTEM STOPS' : null;
    kod=="tv689" ? metin='Istallation Revision Number' : null;
    kod=="tv690" ? metin='SYSTEM\nSTART-STOP' : null;
    kod=="tv691" ? metin='CONNECTION STATE' : null;
    kod=="tv692" ? metin='Connection error!' : null;
    kod=="tv693" ? metin='The connection is timed out!' : null;
    kod=="tv694" ? metin='Connection Refused!' : null;
    kod=="tv695" ? metin='RESET ERROR' : null;
    kod=="tv696" ? metin='An Other/Undefined error occured!' : null;
    kod=="tv697" ? metin='Connection fault between PLC and Server PC!' : null;
    kod=="tv698" ? metin='Error Code' : null;
    kod=="tv699" ? metin='Min. Temp.(°C)' : null;
    kod=="tv700" ? metin='Max. Temp.(°C)' : null;
    kod=="tv701" ? metin='DEFINITION OF ALARM MIN. & MAX TEMP. FOR 7 WEEKLY' : null;
    kod=="tv702" ? metin='ALARM SETTINGS' : null;
    kod=="tv703" ? metin='Min: ' : null;
    kod=="tv704" ? metin='Max: ' : null;
    kod=="tv705" ? metin='MIN' : null;
    kod=="tv706" ? metin='MAX' : null;
    kod=="tv707" ? metin='SET' : null;
    kod=="tv708" ? metin='Set: ' : null;
    kod=="tv709" ? metin='Show\nIntermediate\nValues' : null;
    kod=="tv710" ? metin='Alarm Delay (Sec)\n(for Min-Max values)' : null;
    kod=="tv710a" ? metin='Alarm Delay (Sec) (for Min-Max values)' : null;
    kod=="tv711" ? metin='Daily Min. Consump.(Lt)\n(for 1 watermeter)' : null;
    kod=="tv711a" ? metin='Daily Min. Consump.(Lt) (for 1 watermeter)' : null;
    kod=="tv712" ? metin='Ped Maintenance\nCycle Time(Day)' : null;
    kod=="tv712a" ? metin='Ped Maintenance Cycle Time(Day)' : null;
    kod=="tv713" ? metin='System Maintenance\nCycle Time(Day)' : null;
    kod=="tv713a" ? metin='System Maintenance Cycle Time(Day)' : null;
    kod=="tv714" ? metin='Stop Horn' : null;
    kod=="tv715" ? metin='Stop Time(Sec)' : null;
    kod=="tv716" ? metin='Cancel Alarm Horn' : null;
    kod=="tv717" ? metin='ALARM & WARN STATE' : null;
    kod=="tv718" ? metin='REMOVE ALARM' : null;
    kod=="tv719" ? metin='REMOVE WARNING' : null;
    kod=="tv720" ? metin='ALARM DETAILS' : null;
    kod=="tv721" ? metin='ERROR DETAILS' : null;
    kod=="tv722" ? metin='External Alarms' : null;
    kod=="tv723" ? metin='EXTERNAL ALARMS' : null;
    kod=="tv724" ? metin='Do you want to remove the alarm from the list?' : null;
    kod=="tv725" ? metin='Add new external alarm text...' : null;
    kod=="tv726" ? metin='CANCEL ALARM HORN' : null;
    kod=="tv727" ? metin='REFRESH LİST' : null;
    kod=="tv728" ? metin='LOG AND CHART' : null;
    kod=="tv729" ? metin='DATA LOGS' : null;
    kod=="tv730" ? metin='CHARTS' : null;
    kod=="tv731" ? metin='TEMP. & HUM.\nLOGS' : null;
    kod=="tv732" ? metin='ALARM / WARN\nLOGS' : null;
    kod=="tv733" ? metin='CONSUMPTION\nLOGS' : null;
    kod=="tv734" ? metin='PARAMETER\nLOGS' : null;
    kod=="tv735" ? metin='TEMP. & HUM. LOGS' : null;
    kod=="tv736" ? metin='ALARM / WARN LOGS' : null;
    kod=="tv737" ? metin='CONSUMPTION LOGS' : null;
    kod=="tv738" ? metin='PARAMETER LOGS' : null;
    kod=="tv739" ? metin='Temp. Sensor 1' : null;
    kod=="tv740" ? metin='Temp. Sensor 2' : null;
    kod=="tv741" ? metin='Temp. Sensor 3' : null;
    kod=="tv742" ? metin='Temp. Sensor 4' : null;
    kod=="tv743" ? metin='Temp. Sensor 5' : null;
    kod=="tv744" ? metin='Temp. Sensor 6' : null;
    kod=="tv745" ? metin='Temp. Sensor 7' : null;
    kod=="tv746" ? metin='Temp. Sensor 8' : null;
    kod=="tv747" ? metin='Temp. Sensor 9' : null;
    kod=="tv748" ? metin='Temp. Sensor 10' : null;
    kod=="tv749" ? metin='Temp. Sensor 11' : null;
    kod=="tv750" ? metin='Temp. Sensor 12' : null;
    kod=="tv751" ? metin='Temp. Sensor 13' : null;
    kod=="tv752" ? metin='Temp. Sensor 14' : null;
    kod=="tv753" ? metin='Temp. Sensor 15' : null;
    kod=="tv754" ? metin='Record Type' : null;
    kod=="tv755" ? metin='Log Periyod' : null;
    kod=="tv756" ? metin='Date-First' : null;
    kod=="tv757" ? metin='Date-Last' : null;
    kod=="tv758" ? metin='Min.' : null;
    kod=="tv759" ? metin='Selected Date' : null;
    kod=="tv760" ? metin='RECORD NO' : null;
    kod=="tv761" ? metin='TIME' : null;
    kod=="tv762" ? metin='DATE' : null;
    kod=="tv763" ? metin='VALUE' : null;
    kod=="tv764" ? metin='Highest' : null;
    kod=="tv765" ? metin='Lowest' : null;
    kod=="tv766" ? metin='PARAMETER' : null;
    kod=="tv767" ? metin='Alarm' : null;
    kod=="tv768" ? metin='Warning' : null;
    kod=="tv769" ? metin='OLD VALUE' : null;
    kod=="tv770" ? metin='Electricity-Daily Total' : null;
    kod=="tv771" ? metin='Electricity-Daily Per. Animal' : null;
    kod=="tv772" ? metin='Feed-Daily Total' : null;
    kod=="tv773" ? metin='Feed-Daily Per. Animal' : null;
    kod=="tv774" ? metin='Water-Daily Total' : null;
    kod=="tv775" ? metin='Water-Daily Per. Animal' : null;
    kod=="tv776" ? metin='ANIMAL COUNT' : null;
    kod=="tv777" ? metin='KWh' : null;
    kod=="tv778" ? metin='Lt' : null;
    kod=="tv779" ? metin='Total' : null;
    kod=="tv780" ? metin='Gr' : null;
    kod=="tv781" ? metin='mL' : null;
    kod=="tv782" ? metin='Average' : null;
    kod=="tv783" ? metin='NEW VALUE' : null;
    kod=="tv784" ? metin='USER' : null;
    kod=="tv785" ? metin='NO' : null;
    kod=="tv786" ? metin='Flap Dimensions' : null;
    kod=="tv787" ? metin='Build Dimensions' : null;
    kod=="tv788" ? metin='Flow and Hum.' : null;
    kod=="tv789" ? metin='Fan Map Resetting' : null;
    kod=="tv790" ? metin='Flap Map Resetting' : null;
    kod=="tv791" ? metin='Ped Map Resetting' : null;
    kod=="tv792" ? metin='Temp. Sensor Map Resetting' : null;
    kod=="tv793" ? metin='Chimney F. Map Resetting' : null;
    kod=="tv794" ? metin='Heater Map Resetting' : null;
    kod=="tv795" ? metin='Silo Map Resetting' : null;
    kod=="tv796" ? metin='Stop\nCalibration' : null;
    kod=="tv796a" ? metin='Stop Calibration' : null;
    kod=="tv797" ? metin='A.Inlet Motor KW' : null;
    kod=="tv798" ? metin='Heater KW' : null;
    kod=="tv799" ? metin='Sirc.Fans KW' : null;
    kod=="tv800" ? metin='Lighting KW' : null;
    kod=="tv801" ? metin='STRESS & COMFORT\nCHART' : null;
    kod=="tv801a" ? metin='STRESS & COMFORT CHART' : null;
    kod=="tv802" ? metin='Normal' : null;
    kod=="tv803" ? metin='1. Warn' : null;
    kod=="tv804" ? metin='2. Warn' : null;
    kod=="tv805" ? metin='Danger' : null;
    kod=="tv806" ? metin='Emergency' : null;
    kod=="tv807" ? metin='TEMP. & HUM.\nCHART' : null;
    kod=="tv807a" ? metin='TEMP. & HUM. CHART' : null;
    kod=="tv808" ? metin='AVR.TEMP' : null;
    kod=="tv809" ? metin='IN HUM.' : null;
    kod=="tv810" ? metin='OUT HUM' : null;
    kod=="tv811" ? metin='SENS. TEMP. & HUM.\nCHART' : null;
    kod=="tv811a" ? metin='SENS. TEMP. & HUM. CHART' : null;
    kod=="tv812" ? metin='Sensible Avr. Temp.' : null;
    kod=="tv812a" ? metin='Sensible Avr.\nTemperature' : null;
    kod=="tv813" ? metin='SEN.TEMP.' : null;
    kod=="tv814" ? metin='Temperature' : null;
    kod=="tv815" ? metin='DAILY TEMP. &\nWATER CHART' : null;
    kod=="tv815a" ? metin='DAILY TEMP. & WATER CHART' : null;
    kod=="tv816" ? metin='MONTHLY POWER\nCONSUMPTION CHART' : null;
    kod=="tv816a" ? metin='MONTHLY POWER CONSUMPTION CHART' : null;
    kod=="tv817" ? metin='MONTHLY WATER\nCONSUMPTION CHART' : null;
    kod=="tv817a" ? metin='MONTHLY WATER CONSUMPTION CHART' : null;
    kod=="tv818" ? metin='MONTHLY FOOD\nCONSUMPTION CHART' : null;
    kod=="tv818a" ? metin='MONTHLY FOOD CONSUMPTION CHART' : null;
    kod=="tv819" ? metin='WA.CONS.' : null;
    kod=="tv820" ? metin='TOTAL' : null;
    kod=="tv821" ? metin='PER BIRD' : null;
    kod=="tv822" ? metin='(day.month)' : null;
   
    
    


    
    

    

    
    

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
    kod=="btn11" ? metin='Automatic Sign' : null;
    kod=="btn12" ? metin='START' : null;
    kod=="btn13" ? metin='STOP' : null;
    kod=="btn14" ? metin='ADD' : null;
    kod=="btn15" ? metin='GET' : null;
    kod=="btn16" ? metin='ACTIVE' : null;
    kod=="btn17" ? metin='PASSIVE' : null;
    

    //endregion

    //region TEXTFIELD LABEL

    kod=="tflb1" ? metin='Tun. Fan Flow' : null;
    kod=="tflb2" ? metin='Chim. F. Flow' : null;
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




    //region ALARM VE UYARI LİSTESİ

    kod=="alarm1" ? metin='Emergency stop is pressed!' : null;
    kod=="alarm2" ? metin='Phase sequence error!' : null;
    kod=="alarm3" ? metin='Electricity is cut or main fuse triggered!' : null;
    kod=="alarm4" ? metin='The fuse of one of tunnel fans triggered!' : null;
    kod=="alarm5" ? metin='The fuse of one of flap motors triggered!!' : null;
    kod=="alarm6" ? metin='The fuse of one of ped motors triggered!!' : null;
    kod=="alarm7" ? metin='The fuse of one of air inlet motors triggered!!' : null;
    kod=="alarm8" ? metin='The fuse of one of chimney fans triggered!' : null;
    kod=="alarm9" ? metin='The fuse of one of heaters triggered!!' : null;
    kod=="alarm10" ? metin='The fuse of one of sirc. fans triggered!!' : null;
    kod=="alarm11" ? metin='No water goes to one of the tunnels!' : null;
    kod=="alarm12" ? metin='Minimum temperature!' : null;
    kod=="alarm13" ? metin='Maximum temperature!' : null;
    kod=="alarm14" ? metin='Minimum humidity!' : null;
    kod=="alarm15" ? metin='Maximum humidity!' : null;
    kod=="alarm16" ? metin='Temperature sensor 1 error!' : null;
    kod=="alarm17" ? metin='Temperature sensor 2 error!' : null;
    kod=="alarm18" ? metin='Temperature sensor 3 error!' : null;
    kod=="alarm19" ? metin='Temperature sensor 4 error!' : null;
    kod=="alarm20" ? metin='Temperature sensor 5 error!' : null;
    kod=="alarm21" ? metin='Temperature sensor 6 error!' : null;
    kod=="alarm22" ? metin='Temperature sensor 7 error!' : null;
    kod=="alarm23" ? metin='Temperature sensor 8 error!' : null;
    kod=="alarm24" ? metin='Temperature sensor 9 error!' : null;
    kod=="alarm25" ? metin='Temperature sensor 10 error!' : null;
    kod=="alarm26" ? metin='Temperature sensor 11 error!' : null;
    kod=="alarm27" ? metin='Temperature sensor 12 error!' : null;
    kod=="alarm28" ? metin='Temperature sensor 13 error!' : null;
    kod=="alarm29" ? metin='Temperature sensor 14 error!' : null;
    kod=="alarm30" ? metin='Temperature sensor 15 error!' : null;
    kod=="alarm31" ? metin='Inside humidity sensor error!' : null;
    kod=="alarm32" ? metin='External alarm active!' : null;
    kod=="alarm33" ? metin='Water consumption is under minimum value for sayac 1!' : null;
    kod=="alarm34" ? metin='Water consumption is under minimum value for sayac 2!' : null;
    kod=="alarm35" ? metin='Water consumption is under minimum value for sayac 3!' : null;
    kod=="alarm36" ? metin='Water consumption is under minimum value for sayac 4!' : null;
    kod=="alarm37" ? metin='Water consumption is under minimum value for sayac 5!' : null;
    kod=="alarm38" ? metin='Water consumption is under minimum value for sayac 6!' : null;
    kod=="alarm39" ? metin='Water consumption is under minimum value for sayac 7!' : null;
    kod=="alarm40" ? metin='Water consumption is under minimum value for sayac 8!' : null;
    kod=="alarm41" ? metin='Water consumption is under minimum value for sayac 9!' : null;
    kod=="alarm42" ? metin='Water consumption is under minimum value for sayac 10!' : null;
    kod=="alarm43" ? metin='Water consumption is under minimum value for sayac 11!' : null;
    kod=="alarm44" ? metin='Water consumption is under minimum value for sayac 12!' : null;


    kod=="korna1" ? metin='Emer.\nStop' : null;
    kod=="korna2" ? metin='Phase\nError' : null;
    kod=="korna3" ? metin='Electricity Cut' : null;
    kod=="korna4" ? metin='T. Fan Fuse' : null;
    kod=="korna5" ? metin='Flap Fuse' : null;
    kod=="korna6" ? metin='Ped Fuse' : null;
    kod=="korna7" ? metin='A.Inlet Fuse' : null;
    kod=="korna8" ? metin='C.Fan Fuse' : null;
    kod=="korna9" ? metin='Heater Fuse' : null;
    kod=="korna10" ? metin='Sirc. Fan Fuse' : null;
    kod=="korna11" ? metin='No Water in Tunnel' : null;
    kod=="korna12" ? metin='Minimum Temp.' : null;
    kod=="korna13" ? metin='Maximum Temp' : null;
    kod=="korna14" ? metin='Minimum Humidiyy' : null;
    kod=="korna15" ? metin='Maximum Humidity' : null;
    kod=="korna16" ? metin='Temp. Sens. 1 Error' : null;
    kod=="korna17" ? metin='Temp. Sens. 2 Error' : null;
    kod=="korna18" ? metin='Temp. Sens. 3 Error' : null;
    kod=="korna19" ? metin='Temp. Sens. 4 Error' : null;
    kod=="korna20" ? metin='Temp. Sens. 5 Error' : null;
    kod=="korna21" ? metin='Temp. Sens. 6 Error' : null;
    kod=="korna22" ? metin='Temp. Sens. 7 Error' : null;
    kod=="korna23" ? metin='Temp. Sens. 8 Error' : null;
    kod=="korna24" ? metin='Temp. Sens. 9 Error' : null;
    kod=="korna25" ? metin='Temp. Sens. 10 Error' : null;
    kod=="korna26" ? metin='Temp. Sens. 11 Error' : null;
    kod=="korna27" ? metin='Temp. Sens. 12 Error' : null;
    kod=="korna28" ? metin='Temp. Sens. 13 Error' : null;
    kod=="korna29" ? metin='Temp. Sens. 14 Error' : null;
    kod=="korna30" ? metin='Temp. Sens. 15 Error' : null;
    kod=="korna31" ? metin='Hum. Sens. Error!' : null;
    kod=="korna32" ? metin='External Alarm' : null;
    kod=="korna33" ? metin='W.Meter1 Min. Cons.' : null;
    kod=="korna34" ? metin='W.Meter2 Min. Cons.' : null;
    kod=="korna35" ? metin='W.Meter3 Min. Cons.' : null;
    kod=="korna36" ? metin='W.Meter4 Min. Cons.' : null;
    kod=="korna37" ? metin='W.Meter5 Min. Cons.' : null;
    kod=="korna38" ? metin='W.Meter6 Min. Cons.' : null;
    kod=="korna39" ? metin='W.Meter7 Min. Cons.' : null;
    kod=="korna40" ? metin='W.Meter8 Min. Cons.' : null;
    kod=="korna41" ? metin='W.Meter9 Min. Cons.' : null;
    kod=="korna42" ? metin='W.Meter10 Min. Cons.' : null;
    kod=="korna43" ? metin='W.Meter11 Min. Cons.' : null;
    kod=="korna44" ? metin='W.Meter12 Min. Cons.' : null;


    kod=="uyari61" ? metin='Outside humidity sensor error!' : null;
    kod=="uyari62" ? metin='Outside temperature sensor error!' : null;
    kod=="uyari63" ? metin='it\'s time to maintain for the pad system!' : null;
    kod=="uyari64" ? metin='it\'s time to maintain for the system!' : null;
    
    //endregion





    //region TOAST

    kod=="toast1" ? metin='Plase use atleast 4 character for cage name' : null;
    kod=="toast2" ? metin='Plase define password as 4-digit number' : null;
    kod=="toast3" ? metin='The passwords do not match' : null;
    kod=="toast4" ? metin='One of Fan Control Method must be selected!' : null;
    kod=="toast5" ? metin='You entered bigger than defined klepe number.Please check again!' : null;
    kod=="toast6" ? metin='One of Flap no , X(m), Y(m) values or more are empty!' : null;
    kod=="toast7" ? metin='Invalid entry for Flap No, x(m) or Y(m) value! Please check.' : null;
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
    kod=="toast24" ? metin='Please define Fan Number as nonzero for all selected fans' : null;
    kod=="toast25" ? metin='Same Fan Number assigned for two different fan! Please check.' : null;
    kod=="toast26" ? metin='Same Out Number assigned for two different element! Please check.' : null;
    kod=="toast27" ? metin='Please firstly send defined data!' : null;
    kod=="toast28" ? metin='Same Flap Number assigned for two different flap! Please check.' : null;
    kod=="toast29" ? metin='Number of selected klepes are less then the defined!' : null;
    kod=="toast30" ? metin='Number of selected klepes are more then the defined!' : null;
    kod=="toast31" ? metin='Same Temp. Sensor Number assigned for two different temp. sensor! Please check.' : null;
    kod=="toast32" ? metin='Same Ped Number assigned for two different ped! Please check.' : null;
    kod=="toast33" ? metin='Two of active sensors assigned same number! Please check.' : null;
    kod=="toast34" ? metin='Atleast one active sensor must be assigned!' : null;
    kod=="toast35" ? metin='Please define Temp. Sensor Number as nonzero for all selected temp sensors' : null;
    kod=="toast36" ? metin='Please define Ped Number as nonzero for all selected peds' : null;
    kod=="toast37" ? metin='Please define Flap Number as nonzero for all selected klepes' : null;
    kod=="toast38" ? metin='One of target outputs in use! Please release first the target output' : null;
    kod=="toast39" ? metin='Please define Chimney Fan Number as nonzero for all selected chimney fans on the map' : null;
    kod=="toast40" ? metin='Please define a number equal or smaller than total sensor quantity' : null;
    kod=="toast41" ? metin='Selected sensor number is not define on the map!' : null;
    kod=="toast42" ? metin='Same Air Inlet Number assigned for two different air inlet! Please check.' : null;
    kod=="toast43" ? metin='Command area is empty for sending task command!' : null;
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
    kod=="toast60" ? metin='Wifi connection is selected for the sensor' : null;
    kod=="toast61" ? metin='Analog connection is selected for the sensor' : null;
    kod=="toast62" ? metin='The map must be created and approved!' : null;
    kod=="toast63" ? metin='Please define Output No as nonzero' : null;
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
    kod=="toast73" ? metin='Boooooooooooooooooooooooooşta' : null;
    kod=="toast74" ? metin='Please firstly do active "On-Off Time 2 Activity" option!' : null;
    kod=="toast75" ? metin='It is passive while dimmer option is checked!' : null;
    kod=="toast76" ? metin='Please define an input number for all inputs!' : null;
    kod=="toast77" ? metin='Invalid date error! Please enter a passed date...' : null;
    kod=="toast78" ? metin='Flap is closing now! Openning option is inactive!' : null;
    kod=="toast79" ? metin='Flap is openning now! Closing option is inactive!' : null;
    kod=="toast80" ? metin='Air Inlet is closing now! Openning option is inactive!' : null;
    kod=="toast81" ? metin='Air Inlet is openning now! Closing option is inactive!' : null;
    kod=="toast82" ? metin='This option is inactive because of there is no out hum. sensor which defined ' : null;
    kod=="toast83" ? metin='There is no temperature sensor defined with this number! ' : null;
    kod=="toast84" ? metin='This number defined for outside temp. sensor! Please choose a different number. ' : null;
    kod=="toast85" ? metin='Feed 1 Output isn\'t defined in installation settings! Please check.' : null;
    kod=="toast86" ? metin='Feed 1 Output isn\'t defined in installation settings! Please check.' : null;
    kod=="toast87" ? metin='Feed 1 Output isn\'t defined in installation settings! Please check.' : null;
    kod=="toast88" ? metin='The value more then 1500 sec (25min) is invalid value!' : null;
    kod=="toast89" ? metin='It is invalid hour entering for AM/PM format!' : null;
    kod=="toast90" ? metin='Please define Heater group Output No as nonzero!' : null;
    kod=="toast91" ? metin='Connection timed out!' : null;
    kod=="toast92" ? metin='Invalid Output selected! Please select one of outputs that shows on "OUTPUTS" area' : null;
    kod=="toast93" ? metin='Invalid input selected! Please select one of inputs that shows on "INPUTS" area' : null;
    kod=="toast94" ? metin='Selected inputs is using another control element! Please select a different input' : null;
    kod=="toast95" ? metin='All inputs are signed automatically in order' : null;
    kod=="toast96" ? metin='Same Chimney Fan Number assigned for two different chimney fan! Please check.' : null;
    kod=="toast97" ? metin='There is undefine output! Please define a valid output for all elements' : null;
    kod=="toast98" ? metin='The error is still active, it can\'t reset' : null;
    kod=="toast99" ? metin='The alarm is still active, it can\'t reset' : null;
    kod=="toast100" ? metin='Please enter 10 character atleast for alarm text!' : null;
    kod=="toast101" ? metin='Writing error! Writing port is close.If there is no connection error, reboot server PC' : null;
    kod=="toast102" ? metin='There is no any recorded data for entered month!' : null;
    kod=="toast103" ? metin='There is no any recorede data for entered day interval!' : null;
    kod=="toast104" ? metin='Month and year values must be same for Date-First and Date-Last parameters!' : null;


    //endregion

    return metin;
  }


}