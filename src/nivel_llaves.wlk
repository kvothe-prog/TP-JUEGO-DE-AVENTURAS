import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import utilidades.*

object nivelLlaves {

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image="fondoCompleto2.png"))
				 
		// otros visuals, p.ej. bloques o llaves
			
		var llaves = [new Position(x=2, y=4), new Position(x=7, y=14), new Position(x=14, y=10)]
			.map{ p => self.dibujar(new Llave( position = p )) }
		
		var pollos = [new Position(x=0, y=10), new Position(x=8, y=13), new Position(x=10, y=0)]
			.map{ p => self.dibujar(new Pollo( position = p )) }
		
		var salida = 0
		
		var celda = new CeldaSorpresa(position = game.at(12,10))
		
		var pisoTrampa = celda.celdasAdyacentes()
			.map{ p => self.dibujar(new PisoTrampa( position = p , celdaSorpresa = celda)) }
		
		
		game.addVisual( new Duplicador( position = game.at(4,8) ))
		game.addVisual( new Reforzador( position = game.at(12,13) ))
		game.addVisual( new TripleNada( position = game.at(12,4) ))
		
		game.addVisual(celda)
		
		
		// personaje, es importante que sea el último visual que se agregue
		game.addVisual(personajeSimple)
		
		// teclado
		// este es para probar, no es necesario dejarlo
		keyboard.g().onPressDo({ self.ganar() })
		keyboard.g().onPressDo({ self.ganar() })
		
		keyboard.up().onPressDo({personajeSimple.moverArriba() })
		keyboard.down().onPressDo({ personajeSimple.moverAbajo() })
		keyboard.right().onPressDo({ personajeSimple.moverDerecha() })
		keyboard.left().onPressDo({ personajeSimple.moverIzquierda() })
		keyboard.any().onPressDo({ personajeSimple.restarUnPuntoEnergia() })
		keyboard.any().onPressDo({ if(personajeSimple.perdio()) { self.perder(personajeSimple) } })
		keyboard.any().onPressDo({ game.say(personajeSimple, personajeSimple.informeEnergia() ) })
		keyboard.any().onPressDo({ self.puedeGanar(personajeSimple,llaves) })
		
		// colisiones, acá sí hacen falta
		
		game.whenCollideDo(personajeSimple, { elemento => if ( celda == elemento ) {personajeSimple.retrocede()}
											  else if ( pisoTrampa.any({ p => p == elemento })){ elemento.celdaSorpresa().efecto(personajeSimple) ; elemento.celdaSorpresa().fueActivada()}
										      else {game.removeVisual(elemento)
											  elemento.serRecogido(personajeSimple)
											  self.comprobarSiAgarroTodas(llaves)}  
											  
		})
		
		
	}
	
	method perder(personaje){
		game.removeVisual(personaje)
		game.addVisual( new PersonajeMuerto( position = personaje.position() ) )
	}
	
	method dibujar(dibujo) {
		game.addVisual(dibujo)
		return dibujo
	}
	
	method comprobarSiAgarroTodas(llaves) {
		if (llaves.all{ l => l.fueRecogida() }) {
			var salida = new Salida(position = new Position(x=4, y= 0))
			game.addVisual(salida) 
		}
	}
	
	method puedeGanar(pj, llaves) {
		if (llaves.all({ l => l.fueRecogida() }) and pj.position() == game.at(4,0) ){
			self.ganar()
		}
	}
	
	method restart() {
		game.clear()
		self.configurate()
	}

	method ganar() {
		// es muy parecido al terminar() de nivelBloques
		// el perder() también va a ser parecido
		
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image="fondoCompleto.png"))
		// después de un ratito ...
		game.schedule(2500, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="ganamos.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// fin del juego
				game.stop()
			})
		})
	}
	
	
}
