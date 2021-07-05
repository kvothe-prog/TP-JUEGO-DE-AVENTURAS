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
			
		var llaves = [ utilidadesParaJuego.posicionArbitraria(), utilidadesParaJuego.posicionArbitraria(), utilidadesParaJuego.posicionArbitraria()]
			.map{ p => self.dibujar(new Llave( position = p )) }
		
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
		
		// colisiones, acá sí hacen falta
		
		game.whenCollideDo(personajeSimple, { elemento => game.removeVisual(elemento) 
											  elemento.serRecogido()
		})
		
	}
	
	method dibujar(dibujo) {
		game.addVisual(dibujo)
		return dibujo
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
