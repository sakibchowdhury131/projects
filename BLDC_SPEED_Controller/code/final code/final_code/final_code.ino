int MOSA1 = 3;
int MOSA2 = 4;
int MOSB1 = 5;
int MOSB2 = 6;
int MOSC1 = 7;
int MOSC2 = 8;

//float PU=A1;
int period;



void setup() {
  // put your setup code here, to run once:

  pinMode ( MOSA1, OUTPUT);
  pinMode ( MOSA2, OUTPUT);
  pinMode ( MOSB1, OUTPUT);
  pinMode ( MOSB2, OUTPUT);
  pinMode ( MOSC1, OUTPUT);
  pinMode ( MOSC2, OUTPUT);
  pinMode(A0, INPUT);
  Serial.begin(9600);

}

void loop() {
  //pulse=map(analogRead(PU),0,1023,100,200);
  period=map(analogRead(A0),0,1023,1000,9000);
  
  Serial.println (period);
  
  // put your main code here, to run repeatedly:
  digitalWrite (MOSA1, 1);
  digitalWrite (MOSA2, 0);
  digitalWrite (MOSB1, 0);
  digitalWrite (MOSB2, 1);
  digitalWrite (MOSC1, 0);
  digitalWrite (MOSC2, 0);
  delayMicroseconds( period ); //step1

  digitalWrite (MOSA1, 0);
  digitalWrite (MOSA2, 0);
  digitalWrite (MOSB1, 0);
 digitalWrite (MOSB2, 1);
  digitalWrite (MOSC1, 1);
  digitalWrite (MOSC2, 0);
 delayMicroseconds( period ); //step2


  digitalWrite (MOSA1, 0);
  digitalWrite (MOSA2, 1);
  digitalWrite (MOSB1, 0);
  digitalWrite (MOSB2, 0);
  digitalWrite (MOSC1, 1);
  digitalWrite (MOSC2, 0);
  delayMicroseconds( period ); //step3

  digitalWrite (MOSA1, 0);
  digitalWrite (MOSA2, 1);
  digitalWrite (MOSB1, 1);
  digitalWrite (MOSB2, 0);
  digitalWrite (MOSC1, 0);
  digitalWrite (MOSC2, 0);
 delayMicroseconds( period ); //step4

  digitalWrite (MOSA1, 0);
  digitalWrite (MOSA2, 0);
  digitalWrite (MOSB1, 1);
  digitalWrite (MOSB2, 0);
  digitalWrite (MOSC1, 0);
  digitalWrite (MOSC2, 1);
 delayMicroseconds( period ); //step5

  digitalWrite (MOSA1, 1);
  digitalWrite (MOSA2, 0);
  digitalWrite (MOSB1, 0);
  digitalWrite (MOSB2, 0);
  digitalWrite (MOSC1, 0);
  digitalWrite (MOSC2, 1);
 delayMicroseconds( period ); //step6

}
