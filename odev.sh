#!\bin\sh
cikis=0
while [ cikis != 0 ]
do
 tercih1=$(whiptail --ok-button "Seç" --cancel-button "Çıkış" --menu "Yapmak istediğiniz işlemi seçiniz" 18 100 10 \
  "Ekle" "Bulunmuş olduğunuz konuma bir adet text dosyası ekleme" \
  "Bak" "Olduğunuz dizindeki istediğiniz text uzantılı dosyayı ve içeriğini görme" \
  "Sil" "Olduğunuz dizinde text uzantılı dosyalardan istediğinizi silme" \
  "Degistir" "Seçeceğiniz text uzantılı dosyanın adını değiştir"  3>&1 1>&2 2>&3)
 if [ -z "$tercih1" ]
 then
  if (whiptail --title "Çıkış" --yes-button "Evet" --no-button "Hayır" --yesno "Çıkmak istediğinizden emin misiniz?" 10 60) then
   break
  else
   continue
  fi
 else
  echo "Yapılan seçim $tercih1"
 fi
 if [ $tercih1 = "Ekle" ]
 then
  dosya_adi=$(whiptail --inputbox "Dosyanın adını giriniz" 10 100 3>&1 1>&2 2>&3)
  if [ -z $dosya_adi ]
  then
   if (whiptail --yesno --defaultno "Ana menüye dön" 10 100) then
    continue
   fi
  else
   varmi=$(ls | grep -o $dosya_adi)
   icerik=$(whiptail --inputbox "İçine Yazmak istediğiniz metni giriniz" 50 100 3>&1 1>&2 2>&3)
   if [ -z $icerik  ]
   then
    if (whiptail --yesno --defaultno "Çıkmak istediğinizden emin misiniz?" 10 100) then
     continue
    fi
   else
    if [ -z $varmi ]
    then
     echo $icerik > $dosya_adi
    else
     tercih2=$(whiptail --menu "Girdiğiniz dosya adlı bir .txt dosyası mevcut. Hangi işlem yapılsın?" 18 100 10 \
     "Yaz" "Önceki Dosyayının içeriğini sil ve yeniden yaz" \
     "Ekle" "Önceki dosyanın  yaz"   3>&1 1>&2 2>&3)
     if [ $tercih2 ==  "Yaz" ]
     then
       echo $icerik > $dosya_adi
     elif [ $tercih2 == "Ekle" ]
     then
      wer=$(cat $dosya_adi)
      echo $wer
      wer=$wer" "$icerik
      echo $icerik
      echo $wer
      echo $wer > $dosya_adi
     fi
    fi
   fi
  fi
 elif [ $tercih1 == "Bak" ]
 then
  dosya_adi=$(whiptail --inputbox "Dosyanın adını giriniz" 10 100 3>&1 1>&2 2>&3)
  if [ -z $dosya_adi ]
  then
   if (whiptail --yesno --defaultno "Ana menüye dön" 10 100) then
    continue
   fi
  else
   varmi=$(ls | grep -o $dosya_adi)
   #varmi=$(ls -al)
   echo $varmi
   if [ -z $varmi ]
    then
     whiptail --msgbox "Dosya Yok." 10 100
     #whiptail --textbox $dosya_adi 10 100 --scrolltext
   else
    #ls | grep .txt$
    whiptail --msgbox "Dosya Var." 10 100
    whiptail --textbox $dosya_adi 10 100 --scrolltext
   fi
  fi
 elif [ $tercih1 == "Sil" ]
 then
  dosya_adi=$(whiptail --inputbox "Dosyanın adını giriniz" 10 100 3>&1 1>&2 2>&3)
  if [ -z $dosya_adi ]
  then
   if (whiptail --yesno --defaultno "Ana menüye dön" 10 100) then
    continue
   fi
  else
   varmi=$(ls | grep -o $dosya_adi)
   if [ -z $varmi ]
   then
    whiptail --msgbox "Dosya Yok." 10 100
   elif [ $varmi == $dosya_adi ]
   then
    dosya_boyutu=$(wc -m $dosya_adi)
    echo "çalışıyor "
    read -ra arr <<< "$dosya_boyutu"
    echo ${arr[0]}
    if [ ${arr[0]} ]
    then
     if (whiptail --title "Emin Misiniz?" --yes-button "Evet" --no-button "Hayır" --yesno "Dosyanın içeriği boş değil. Silmek istediğinizden emin misiniz?" 10 60) then
      rm $dosya_adi
      whiptail --msgbox "Dosya Silindi." 10 100
     else
      whiptail --msgbox "Dosya Silinmedi." 10 100
     fi
    fi
   fi
  fi
 elif [ $tercih1 == "Degistir"  ]
 then
  dosya_adi=$(whiptail --inputbox "Değiştirmek istediğin dosyanın adını giriniz" 10 100 3>&1 1>&2 2>&3)
  if [ -z $dosya_adi ]
  then
   if (whiptail --yesno --defaultno "Ana menüye dön" 10 100) then
    continue
   fi
  else
   varmi=$(ls | grep -o $dosya_adi)
   if [ -z $varmi ]
   then
    whiptail --msgbox "Dosya Yok." 10 100
   else
    yeni_dosya_adi=$(whiptail --inputbox "Dosyanın yeni adını giriniz" 10 100 3>&1 1>&2 2>&3)
    if [ -z $yeni_dosya_adi ]
    then
     if (whiptail --yesno --defaultno "Ana menüye dön" 10 100) then
      continue
     fi
    else
     {
       	  for i in {0..100..1}
 	  do
 	  sleep 0.1
 	  echo $i
	  if [ $i == 58 ]
	  then
	   sleep 3
	  fi
 	  done
     } | whiptail --gauge "Dosya adı değiştiriliyor. Lütfen Bekleyiniz." 6 60 0
    mv $dosya_adi $yeni_dosya_adi
    whiptail --msgbox "Başarıyla Değiştirildi." 10 100
    fi
   fi
  fi
 fi
done

