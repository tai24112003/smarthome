#include <LiquidCrystal_I2C.h>
#include <Servo.h>
Servo myservo;
LiquidCrystal_I2C lcd(0X27, 16, 2);
unsigned long t_high = 0;
unsigned long t_high2 = 0;
unsigned long t_low = 0;
int trim_led_p1 = 0;  // Giá trị hiện tại của biến trở
int trim_led_p = 0;
String pass = "1010";
String pass_in = "";
bool system_lock = true;

String receivedChar;
short pass_wrong = 0;
short btn_pass = 2;
//led system
short btn_toilet = 0;
// short led_toilet = 1;
short btn_san_khach = 3;
short btn_hl_bep = 4;
//short servo = 7;

short pot_p1 = A0;
short pot_p2 = A1;
// short btn_baodong = 17;
//short btn_toilet=6;
short led_san = 8;
short led_khach = 9;
short led_hl = 12;
short led_p1 = 11;
short led_p = 5;
short led_bep = 13;
//short led_toilet=13;
//Status
bool stt_btn_san_khach = false;
bool stt_btn_hl = false;
bool stt_btn_p1 = false;
bool stt_btn_p2 = false;
// bool stt_baodong = false;
bool stt_toilet = false;
bool stt_led_san = LOW;
bool stt_led_khach = LOW;
bool stt_led_hl = LOW;
bool stt_led_p1 = LOW;
bool stt_led_p = LOW;
bool stt_led_bep = LOW;
bool stt_pot_p1 = false;
bool stt_pot_p2 = false;

int dosang = 0;
int dosang2 = 0;
int dosang_l = 0;
int dosang2_l = 0;
bool isApp = false;
bool isApp2 = false;

int value_pot1_l = 0;
int value_pot2_l = 0;

bool stt_servo = false;
unsigned long time_quay = 0;

short led_san_khach = 0;
short led_p1_hl = 0;
short led_p_hl = 0;
short led_hl_bep = 0;
bool baodong = false;
bool pushed = false;
bool pushed2 = false;
//LCD
short col = 0;
unsigned long time_open = 0;
void setup() {
  Serial.begin(9600);
  lcd.init();
  lcd.backlight();
  myservo.attach(7);
  // pinMode(btn_toilet, INPUT);
  pinMode(btn_san_khach, INPUT);
  pinMode(btn_hl_bep, INPUT);
  pinMode(pot_p1, INPUT);
  pinMode(pot_p2, INPUT);
  pinMode(btn_pass, INPUT);
  //  pinMode(btn_baodong, INPUT);
  pinMode(led_san, OUTPUT);
  pinMode(led_khach, OUTPUT);
  pinMode(led_hl, OUTPUT);
  pinMode(led_p1, OUTPUT);
  pinMode(led_p, OUTPUT);
  pinMode(led_bep, OUTPUT);
  //  pinMode(led_toilet, OUTPUT);
}

void loop() {
  unsigned long t_cur = millis();
  int btn_cur_stt = digitalRead(btn_pass);
  int value_pot_p1 = analogRead(pot_p1);
  int value_pot_p2 = analogRead(pot_p2);
  if (value_pot_p1 > value_pot1_l + 25 || value_pot_p1 < value_pot1_l - 25) {
    value_pot1_l = value_pot_p1;
    isApp = false;
    pushed = false;
  }
  if (value_pot_p2 > value_pot2_l + 25 || value_pot_p2 < value_pot2_l - 25) {
    value_pot2_l = value_pot_p2;
    isApp2 = false;
    pushed2 = false;
  }
  while (Serial.available() > 0) {
    receivedChar = Serial.readString();
    // Xử lý dữ liệu từ ESP8266 (ví dụ: in ra Serial Monitor)
    int vt = receivedChar.indexOf(":");

    String key = receivedChar.substring(0, vt);
    String value = receivedChar.substring(vt + 1);
    key.trim();
    value.trim();

    if (key.equals("led_ngu1")) {
      dosang = value.toInt();
      if (dosang != dosang_l) {
        dosang_l = dosang;
        isApp = true;
      }
    }
    if (key.equals("led_ngu2")) {
      dosang2 = value.toInt();
      if (dosang2 != dosang2_l) {
        dosang2_l = dosang2;
        isApp2 = true;
      }
    }
    bool boolvalue;

    boolvalue = value == "1";
    if (key.equals("led_san"))
      stt_led_san = boolvalue;
    if (key.equals("led_khach"))
      stt_led_khach = boolvalue;
    if (key.equals("led_hl"))
      stt_led_hl = boolvalue;
    if (key.equals("led_bep"))
      stt_led_bep = boolvalue;
    if (key.equals("servo"))
      stt_servo = boolvalue;
    if (key.equals("led_ngu1"))
      dosang = value.toInt();
    if (key.equals("led_ngu2"))
      dosang2 = value.toInt();
    if (key.equals("system_lock"))
      system_lock = boolvalue;
    if (key.equals("baodong"))
      baodong = boolvalue;
  }
  switch (system_lock) {
    case true:
      // Serial.print(digitalRead(btn_toilet));
      lcd.setCursor(0, 0);
      lcd.print("Khoa He Thong");
      if (btn_cur_stt == 1) {

        if (t_high == 0)
        //Truoc do chua high gio bat dau high-->bat dau thao tac
        {
          t_high = t_cur;
        } else if (t_low != 0 && t_high2 == 0)
        //da high xong lan 1 (co t_low), high lan 2
        {
          t_high2 = t_cur;
        }
      } else {
        if (t_high2 != 0 && t_cur - t_high <= 1000)
        //da high lan 2 va thoi gian <= 1s
        {
          t_high = 0;
          t_high2 = 0;
          t_low = 0;
          pass_in += "1";
          lcd.clear();

          //          Serial.println(pass_in);

        } else {
          if (t_high != 0 && t_cur - t_high > 1000)
          //da high lan 1 va thoi gian > 1000
          {

            t_high = 0;
            t_high2 = 0;
            t_low = 0;
            pass_in += "0";
            lcd.clear();

            //            Serial.println(pass_in);

          } else {
            if (t_high != 0)
            //Neu da co high thi moi cap nhat t_low
            {
              t_low = t_cur;
            }
          }
        }
      }
      if (pass_in.length() == pass.length()) {
        if (pass == pass_in) {
          pass_in = "";

          time_open = millis();
          system_lock = false;
          Serial.println("system_lock:0");
        } else {
          lcd.setCursor(0, 1);
          lcd.print("Sai MK");

          pass_wrong++;
          pass_in = "";
          //          Serial.println("Sai r ni oi");
          // Serial.println(pass_wrong);
        }
      }
      if (pass_wrong > 2) {
        //Xử lí chơp đèn
        if (millis() % 50 == 0) {
          digitalWrite(led_san, !digitalRead(led_san));
        }
        // Serial.println("Chop den thoai");
        if (pass_in.length() == pass.length()) {
          if (pass == pass_in) {
            pass_in = "";
            system_lock = false;
            //            Serial.println("Voo he thong nha ni");
            time_open = millis();

          } else {
            pass_wrong++;
            pass_in = "";
            lcd.setCursor(0, 1);
            lcd.print("Sai MK");
            //            Serial.println("Sai r ni oi");
            //            Serial.println(pass_wrong);
          }
        }
      }

      lcd.setCursor(0, 1);
      lcd.print(pass_in);
      break;
    case false:
      if (millis() % 100 == 0) {
        col++;
        lcd.clear();
      }
      stt_pot_p1 = true;
      stt_pot_p2 = true;

      lcd.setCursor(col, 0);
      lcd.print("WELCOME!!");


      if (stt_pot_p1 == true) {
        if (isApp) {
          analogWrite(led_p1, dosang);
        } else {

          if (!pushed) {
            analogWrite(led_p1, map(value_pot_p1, 0, 1023, 0, 255));
            Serial.println("led_ngu1: " + String(map(value_pot_p1, 0, 1023, 0, 255)));
            pushed = true;
          }
        }
      }
      if (stt_pot_p2 == true) {

        if (isApp2) {
          analogWrite(led_p, dosang2);
        } else {
          //Serial.println(String(map(value_pot_p2, 0, 1023, 0, 255)));
          if (!pushed2) {
            analogWrite(led_p, map(value_pot_p2, 0, 1023, 0, 255));
            Serial.println("led_ngu2: " + String(map(value_pot_p2, 0, 1023, 0, 255)));
            pushed2 = true;
          }
        }
      }




      if (digitalRead(btn_san_khach)) {

        if (stt_btn_san_khach == false) {
          stt_btn_san_khach = true;
          led_san_khach++;
          if (led_san_khach >= 4)
            led_san_khach = 0;

          switch (led_san_khach) {
            case 0:
              stt_led_san = 0;
              stt_led_khach = 0;
              break;
            case 1:

              stt_led_san = 0;
              stt_led_khach = 1;
              break;
            case 2:

              stt_led_san = 1;
              stt_led_khach = 0;
              break;
            case 3:

              stt_led_san = 1;
              stt_led_khach = 1;
              break;
          }
          String s = "led_san: ";
          s.concat(stt_led_san);
          Serial.println(s);
          s = "led_khach: ";
          s.concat(stt_led_khach);
          Serial.println(s);
        }
      } else {

        stt_btn_san_khach = false;
      }
      digitalWrite(led_san, stt_led_san);
      digitalWrite(led_khach, stt_led_khach);
      if (digitalRead(btn_hl_bep)) {
        if (stt_btn_hl == false) {
          led_hl_bep++;
          if (led_hl_bep > 3)
            led_hl_bep = 0;
          stt_btn_hl = true;
          switch (led_hl_bep) {
            case 0:
              stt_led_hl = 0;
              stt_led_bep = 0;
              break;
            case 1:
              stt_led_hl = 0;
              stt_led_bep = 1;
              break;
            case 2:
              stt_led_hl = 1;
              stt_led_bep = 0;
              break;
            case 3:
              stt_led_hl = 1;
              stt_led_bep = 1;
              break;
          }
          String s = "led_bep: ";
          s.concat(stt_led_bep);
          Serial.println(s);
          s = "led_hl: ";
          s.concat(stt_led_hl);
          Serial.println(s);
        }

      } else {
        stt_btn_hl = false;
      }
      digitalWrite(led_bep, stt_led_bep);
      digitalWrite(led_hl, stt_led_hl);
      // if (digitalRead(btn_p1)) {

      //   if (stt_btn_p1 == false) {
      //     stt_btn_p1 = true;
      //     led_p1_hl++;
      //     if (led_p1_hl >= 3)
      //       led_p1_hl = 0;
      //     // Serial.println(led_p1_hl);
      //   }
      // } else {

      //   stt_btn_p1 = false;
      // }
      // switch (led_p1_hl) {
      //   case 0:
      //     digitalWrite(led_p1, 0);
      //     break;
      //   case 1:
      //     analogWrite(led_p1, 255);
      //     break;
      //   case 2:
      //     analogWrite(led_p1, 50);
      //     ;
      //     break;
      // }
      // if (digitalRead(btn_p2)) {

      //   if (stt_btn_p2 == false) {
      //     stt_btn_p2 = true;
      //     led_p_hl++;
      //     if (led_p_hl >= 3)
      //       led_p_hl = 0;
      //     // Serial.println(led_p_hl);
      //   }
      // } else {

      //   stt_btn_p2 = false;
      // }
      // switch (led_p_hl) {
      //   case 0:
      //     digitalWrite(led_p, 0);
      //     break;
      //   case 1:
      //     analogWrite(led_p, 255);
      //     break;
      //   case 2:
      //     analogWrite(led_p, 50);
      //     ;
      //     break;
      // }


      if (baodong == true) {
        if (millis() % 10 == 0) {
          digitalWrite(led_san, !digitalRead(led_san));
          digitalWrite(led_hl, !digitalRead(led_hl));
          digitalWrite(led_khach, !digitalRead(led_khach));
          digitalWrite(led_p1, !digitalRead(led_p1));
          digitalWrite(led_p, !digitalRead(led_p));
          digitalWrite(led_bep, !digitalRead(led_bep));
        }
      }

      if (stt_servo == true) {
        myservo.write(180);
        stt_servo = false;
        String s = "servo: "+String(stt_servo);
        Serial.println(s);
        time_quay = millis();
      } else if (millis() - time_quay >= 2000) {
        myservo.write(90);
        time_quay = millis();
      }
      if (btn_cur_stt == 1) {
        if (t_high == 0)
        //Truoc do chua high gio bat dau high-->bat dau thao tac
        {
          t_high = t_cur;
        } else if (t_low != 0 && t_high2 == 0)
        //da high xong lan 1 (co t_low), high lan 2
        {
          t_high2 = t_cur;
        }
      } else {
        if (t_high != 0 && t_high2 == 0 && t_cur - t_high >= 3000)
        //da high lan 1 va chua high lan 2 nhung thoi gian thuc hien qua 3s
        {
          //          Serial.println("Nhan giu!");
          t_high = 0;
          t_low = 0;
          system_lock = true;
          Serial.println("system_lock:1");
          pass_in = "";
          pass_wrong = 0;
          col = 0;
          stt_pot_p1 = false;
          stt_pot_p2 = false;

          digitalWrite(led_san, 0);
          digitalWrite(led_khach, 0);
          digitalWrite(led_hl, 0);
          digitalWrite(led_p1, 0);
          digitalWrite(led_p, 0);
          digitalWrite(led_bep, 0);
          led_p1_hl = 0;
          led_san_khach = 0;
          led_p_hl = 0;
          led_hl_bep = 0;

          lcd.clear();
        } else {
          if (t_high != 0 && t_cur - t_high > 1000)
          //da high lan 1 va thoi gian > 1000
          {
            if (t_high2 != 0 && t_cur - t_high2 >= 3000)
            //thoi gian high lan 2 >3s
            {
              //              Serial.println("Nhan giu!");
              t_high = 0;
              t_high2 = 0;
              t_low = 0;
              col = 0;


              system_lock = true;
              Serial.println("system_lock:1");
              stt_pot_p1 = false;
              stt_pot_p2 = false;
              pass_in = "";
              pass_wrong = 0;
              digitalWrite(led_san, 0);
              digitalWrite(led_khach, 0);
              digitalWrite(led_hl, 0);
              digitalWrite(led_p1, 0);
              digitalWrite(led_p, 0);
              digitalWrite(led_bep, 0);
              led_p1_hl = 0;
              led_san_khach = 0;

              led_p_hl = 0;
              led_hl_bep = 0;
              lcd.clear();
            }
          } else {
            if (t_high != 0)
            //Neu da co high thi moi cap nhat t_low
            {
              t_low = t_cur;
            }
          }
        }
      }
      break;
  }
}
