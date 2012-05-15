package net.mte {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.net.SharedObjectFlushStatus;
	import flash.text.TextField;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	public class Torta extends MovieClip {
		
		//Torta in uso
		private var cake:MovieClip;
		//Stage
		private var _stage:Stage;
		//Punteggio
		private var punteggio, tortecampo_:TextField;
		private var punto_1, punto_2, punto_3:MovieClip;
		//Intervallo in uso
		private var Interval, Interval2,Interval3, Interval_m1, Interval_m2, Interval_m3 = null;
		//Stato torta
		private var stato:Number;
		//Pupazzo Sinistra
		private var __man_s:MovieClip;
		//Pupazzo Destra
		private var __man_d:MovieClip;
		//Spostamento Torta
		private var iter = 1;
		private var verso_n = -60;
		//per il riposizionamento alla caduta
		private var casca = false;
		private var xcasca = 0;
		private var ycasca = 0;
		//se la torta è sul rullo è true
		private var partita = false;
		//Alzamento in corso
		private var checkalza = false;
		private var rullo = 1;
		//spostatorta timer
		var Timert:Timer = new Timer(800);
		
		//Init
		public function Torta(object, punti, stage, punto1, punto2, punto3, tortecampo) {
			cake = object;
			punteggio = punti;
			punto_1 = punto1;
			punto_2 = punto2;
			punto_3 = punto3;
			tortecampo_ = tortecampo;
			_stage = stage;
			cake.gotoAndStop(1);
			x_(758);
			y_(506);
			stato = 1;
			polvere(cake.x, cake.y);
			movimentoTorta();
			Interval = setInterval(function() {
					spostaTorta();
				}, 100);
		}
		
		//Animazione torta
		public function movimentoTorta() {
			Interval3 = setInterval(function() {
				if (iter == 2 && rullo == 1 && __man_d.posizione != 0 && Interval2 == null) {
							//Appena uscita nessuno prende faccio cadere
								Interval2 = setTimeout(function() {
										cascaTorta(iter);
									}, 300);
				}
			},100);
			Timert.addEventListener(TimerEvent.TIMER, function() {
				//Verifico se alla fine del rullo e in caso fermo e aspetto se far cadere
					if ((iter == 10 && rullo == 1 || rullo > 1 && iter == 7) && Interval2 == null) {
						Interval2 = setTimeout(function() {
								cascaTorta(iter);
							}, 300);
					}
					//Se non è alla fine sposta la torta
					if (casca == false && Interval2 == null && (rullo == 1 && iter < 10 || rullo != 1 && iter < 7)) {
						if (iter == 6 && rullo == 1 || iter == 3 && rullo != 1) {
							statoTorta(iter);
							x_(verso_n);
							iter++;
						} else if (checkalza == false) {
							//Se non si sta alzando muovi la torta
							x_(verso_n);
							iter++;
						}
					}
				});
			Timert.start();
		}
		
		//Spostamento torta sui rulli
		public function spostaTorta() {
			if (casca == false) {
				if (__man_s.checkScala() == false && __man_s.checkSposta() == false) {
					//Sposta secondo rullo
					if (__man_s.posizione == 0 && iter == 10 && rullo == 1) {
						riposiziona();
						iter = 1;
						__man_s.spostaTorta(1, 2);
						alzaTorta();
					} //Sposta quarto rullo
					else if (__man_s.posizione == 1 && iter == 7 && rullo == 3) {
						riposiziona();
						iter = 1;
						__man_s.spostaTorta(1, 2);
						alzaTorta();
					} //Posa finita
					else if (__man_s.posizione == 2 && iter == 7 && rullo == 5) {
						riposiziona();
						iter = 1;
						__man_s.spostaTorta(2, 2);
						alzaTorta();
					}
				}
				if (__man_d.checkScala() == false && __man_d.checkSposta() == false) {
					//Mette su rullo
					if (__man_d.posizione == 0 && iter == 2 && rullo == 1 && partita == false) {
						iter++;
						riposiziona();
						alzaTorta();
						__man_d.spostaTorta(1, 1);
					} //Sposta terzo rullo
					else if (__man_d.posizione == 1 && iter == 7 && rullo == 2) {
						riposiziona();
						iter = 1;
						__man_d.spostaTorta(2, 1);
						alzaTorta();
					} //Sposta quinto rullo
					else if (__man_d.posizione == 2 && iter == 7 && rullo == 4) {
						riposiziona();
						iter = 1;
						__man_d.spostaTorta(2, 1);
						alzaTorta();
					}
				}
			}
		}
		
		//Stato torta
		public function statoTorta(iter) {
			polvere(cake.x - ( -verso_n), cake.y);
			var urlf:String = "./audio/up.mp3";
			var songf:SoundChannel;
			var requestf:URLRequest = new URLRequest(urlf);
			var soundFactoryf:Sound = new Sound();
			soundFactoryf.load(requestf);
			songf = soundFactoryf.play();
			stato += 1;
			cake.gotoAndStop(stato);
		}
		
		//Alza Torta
		public function alzaTorta() {
			var xprima:Number = cake.x;
			//Prendi la posizione della torta prima che l'alzo
			if (xcasca != 0) {
				cake.x = xcasca;
				cake.y = ycasca;
				xcasca = 0;
			}
			//Alzo la torta a seconda della posizione
			if (stato == 1) {
				partita = true;
				setTimeout(function() {
						x_(verso_n / 2);
						y_(-5);
					}, 300);
				setTimeout(function() {
						x_(verso_n / 2);
						y_(-7);
					}, 600);
			} else if (stato == 2) {
				checkalza = true;
				setTimeout(function() {
						x_(verso_n / 2);
						y_(-20);
					}, 200);
			} else if (stato == 3) {
				checkalza = true;
				setTimeout(function() {
						x_(verso_n / 2);
						y_(-14);
					}, 200);
			} else if (stato == 4) {
				checkalza = true;
				setTimeout(function() {
						x_(verso_n / 2);
						y_(-18);
					}, 200);
			} else if (stato == 5) {
				checkalza = true;
				setTimeout(function() {
						x_(verso_n / 2);
						y_(-14);
					}, 200);
			} else if (stato == 6) {
				checkalza = true;
				setTimeout(function() {
						x_(verso_n / 2);
						y_(-12);
					}, 200);
			}
			if (stato > 1 && stato != 6) {
				rullo += 1;
				Timert.stop();
				setTimeout(function() {
						y_(-10);
					}, 500);
				setTimeout(function() {
						y_(-5);
					}, 600);
				setTimeout(function() {
						y_(-24);
						cake.x = xprima;
						verso_n *= -1;
						checkalza = false;
						Timert.start();
					}, 700);
			} else if (stato == 6) {
				stopFermo();
				setTimeout(function() {
						x_(verso_n / 2);
						y_(-5);
					}, 300);
				setTimeout(function() {
						x_(verso_n / 2);
						y_(-7);
					}, 600);
				setTimeout(function() {
						x_(verso_n);
						fineTorta();
					}, 800);
			}
		}
		
		//X torta
		public function x_(valore:Number) {
			cake.x += valore;
			return valore;
		}
		
		//Y torta
		public function y_(valore:Number) {
			cake.y += valore;
			return valore;
		}
		
		//Fermo l'animazione
		public function stopFermo() {
			iter = 0;
			Timert.stop();
		}
		
		//Passo i pupazzi alla classe
		public function pupazzi(man_s_, man_d_) {
			__man_s = man_s_;
			__man_d = man_d_;
		}
		
		//Fine della torta
		public function fineTorta() {
			punteggio.text = String(int(punteggio.text) + 1);
			stopFermo();
			clearInterval(Interval);
			Interval = null;
			var urlf:String = "./audio/point.mp3";
			var songf:SoundChannel;
			var requestf:URLRequest = new URLRequest(urlf);
			var soundFactoryf:Sound = new Sound();
			soundFactoryf.load(requestf);
			songf = soundFactoryf.play();
			kill();
			setTimeout(function() {
					polvere(cake.x, cake.y);
					_stage.removeChild(cake);
					tortecampo_.text = String(int(tortecampo_.text) - 1);
					delete this;
				}, 500);
		}
		
		//Casca la torta
		public function cascaTorta(iter) {
			xcasca = cake.x;
			ycasca = cake.y;
			//Cade a sinistra
			if (rullo == 1 || rullo == 3 || rullo == 5) {
				cake.rotation = 335;
				cake.x -= 15;
				if (iter == 2) {
					cake.x += 15;
				}
				cake.scaleX = -1;
				Interval_m1 = setTimeout(function() {
						cake.rotation = 315;
						cake.x -= 4;
						casca = true;
					}, 300);
				Interval_m2 = setTimeout(function() {
						cake.rotation = 285;
						cake.x -= 10;
						cake.y += 10;
					}, 500);
				Interval_m3 = setTimeout(function() {
						cake.rotation = 205;
						cake.x -= 6;
						if (iter == 2) {
							cake.y += 40;
						} else {
							cake.y = 560;
						}
						stopFermo();
						eliminaTorta();
					}, 900);
			} //Cade a destra
			else if (rullo == 2 || rullo == 4) {
				cake.rotation = 35;
				cake.x += 20;
				Interval_m1 = setTimeout(function() {
						cake.rotation = 55;
					}, 300);
				Interval_m2 = setTimeout(function() {
						cake.rotation = 85;
						cake.x += 10;
					}, 500);
				Interval_m3 = setTimeout(function() {
						cake.rotation = 160;
						cake.x += 6;
						cake.y = 560;
						stopFermo();
						eliminaTorta();
					}, 900);
			}
		}
		
		//Riposiziona azzerando i vari intervalli e ripristinando la posizione
		public function riposiziona() {
			kill();
			cake.rotation = 0;
			if (xcasca != 0) {
				cake.x = xcasca;
				cake.y = ycasca;
			}
			if (casca == true) {
				casca = false;
				ycasca = 0;
				xcasca = 0;
			}
		}
		
		//Elimina intervalli vari
		private function kill() {
			clearTimeout(Interval2);
			Interval2 = null;
			clearTimeout(Interval_m1);
			Interval_m1 = null;
			clearTimeout(Interval_m2);
			Interval_m2 = null;
			clearTimeout(Interval_m3);
			Interval_m3 = null;
		}
		
		//Elimina torta
		public function eliminaTorta() {
			var urlf:String = "./audio/fall.mp3";
			var songf:SoundChannel;
			var requestf:URLRequest = new URLRequest(urlf);
			var soundFactoryf:Sound = new Sound();
			soundFactoryf.load(requestf);
			songf = soundFactoryf.play();
			clearInterval(Interval);
			Interval = null;
			kill();
			
			setTimeout(function() {
					_stage.removeChild(cake);
					tortecampo_.text = String(int(tortecampo_.text) - 1);
					delete this;
				}, 800);
			import fl.motion.AdjustColor;
			import flash.filters.ColorMatrixFilter;
			var color:AdjustColor = new AdjustColor();
			color.brightness = -50;
			color.contrast = -20;
			color.hue = 0;
			color.saturation = 0;
			//Oscura il conteggio vite
			if (punto_1.alpha == 1) {
				punto_1.alpha = 0.99;
				punto_1.filters = [new ColorMatrixFilter(color.CalculateFinalFlatArray())];
			} else if (punto_2.alpha == 1) {
				punto_2.alpha = 0.99;
				punto_2.filters = [new ColorMatrixFilter(color.CalculateFinalFlatArray())];
			} else if (punto_3.alpha == 1) {
				punto_3.alpha = 0.99;
				punto_3.filters = [new ColorMatrixFilter(color.CalculateFinalFlatArray())];
			} else {
				trace("perso");
			}
		}
		
		//Nuvola
		public function polvere(x, y) {
			var puff:nuvola = new nuvola();
			_stage.addChild(puff);
			puff.x = x;
			puff.y = y-4;
		}
	}
}