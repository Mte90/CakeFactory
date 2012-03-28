package net.mte {
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	public class GeneraTorta extends MovieClip {
		//Init
		public function GeneraTorta() {
		
		}
		
		//Aggiungere torta si o no?
		public function make(create, secondi,turnoprima) {
			/* Il tempo massimo sono 10 min quindi 600 sec
			 * Se io sottraggo al totale i secondi al momento
			 * li divido per 2 così ottengo la metà e di questo prendo un valore casuale
			 * se è maggiore della metà genera
			 * */
			//se gioco iniziato aggiungo torta subito
			if (create == 1) {
				return true
			} else if(turnoprima == false) {
				var sott = 600 - secondi;
				var diff = sott / create;
				var prob = Math.floor((Math.random() * diff));
				if (prob > (diff / 2)) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}
	}

}