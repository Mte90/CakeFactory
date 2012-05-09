package net.mte {
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	public class Pupazzo extends MovieClip {
		//Omino in uso
		public var man:MovieClip;
		//Animazione scala in corso
		private var scalaincorso:Boolean = false;
		//Animazione sposta torta incorso
		private var spostaincorso:Boolean = false;
		//Intervallo in uso quindi se stopFermo fermerà tutte le animazioni
		private var Interval;
		//Posizione del pupazzo 0-2
		public var posizione:Number = 0;
		//Posizione x
		private var x_:Number;
		
		//Init
		public function Pupazzo(object) {
			man = object;
			x_ = man.x;
			fermo();
		}
		
		//Animazione scala
		public function scaleSaliScendi(verso:Boolean) {
			if (checkScala() == false && checkSposta() == false) {
				stopFermo();
				scalaincorso = true;
				var npoggio:Number = -1;
				man.gotoAndStop(1);
				var iter = 0;
				Interval = setInterval(function() {
						if (verso == true) {
							man.y -= 14;
						} else {
							man.y += 14;
						}
						npoggio = -npoggio;
						man.gotoAndStop(npoggio + man.currentFrame);
						iter++;
						if (iter == 8) {
							if (verso == true) {
								posizione += 1;
							} else {
								posizione -= 1;
							}
							fermo();	
						}
					}, 80);
			}
		}
		
		//Verifica se l'animazione scala è in corso
		public function checkScala():Boolean {
			return scalaincorso;
		}
		
		//Animazione fermo
		public function fermo() {
			stopFermo();
			var npoggio:Number = 1;
			man.gotoAndStop(4);
			Interval = setInterval(function() {
					npoggio = -npoggio;
					man.gotoAndStop(npoggio + man.currentFrame);
				}, 300);
			scalaincorso = false;
			spostaincorso = false;
		}
		
		//Fermo le animazioni
		public function stopFermo() {
			clearInterval(Interval);
			Interval = null;
		}
		
		//Sposta torta
		public function spostaTorta(caso:Number, verso:Number) {
			if (checkScala() == false && checkSposta() == false) {
				stopFermo();
				man.gotoAndStop(8);
				var iter = 0;
				spostaincorso = true;
				if (caso == 1 && verso == 1 || caso == 2 && verso == 2) {
					var giro = 1;
					Interval = setInterval(function() {
							iter++;
							man.gotoAndStop(man.currentFrame + giro);
							if (iter == 2) {
								giro = -1;
								man.scaleX = -1;
								man.x = x_ + 57;
							} else if (iter == 3) {
								setTimeout(function() {
										fermo();
										man.scaleX = 1;
										man.x = x_;
									}, 300);
							}
						}, 300);
				} else if (caso == 1 && verso == 2) {
					man.gotoAndStop(7);
					Interval = setInterval(function() {
							iter++;
							man.gotoAndStop(man.currentFrame + 1);
							if (iter == 3) {
								setTimeout(function() {
										fermo();
									}, 300);
							}
						}, 300);
				} else if (caso == 2 && verso == 1) {
					man.gotoAndStop(7);
					man.scaleX = -1;
					man.x = x_ + 57;
					Interval = setInterval(function() {
							iter++;
							man.gotoAndStop(man.currentFrame + 1);
							if (iter == 3) {
								setTimeout(function() {
										fermo();
										man.scaleX = 1;
										man.x = x_;
									}, 300);
							}
						}, 300);
				}
			}
		}
		
		//Verifica se l'animazione sposta è in corso
		public function checkSposta():Boolean {
			return spostaincorso;
		}
	
	}
}