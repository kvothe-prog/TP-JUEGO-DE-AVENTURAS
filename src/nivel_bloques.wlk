import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel_llaves.*


object nivelBloques {

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image="fondoCompleto.png"))
				 
		// otros visuals, p.ej. bloques o llaves
		var cajas = [new Position(x=4, y=8), new Position(x=6, y=4), new Position(x=12, y=12), new Position(x=12, y=1), new Position(x=2, y=2)]
			.map{ p => self.dibujar(new Caja( position = p )) }
				
		// personaje, es importante que sea el último visual que se agregue
		game.addVisual(personajeSimple)
		
		// teclado
		// este es para probar, no es necesario dejarlo

		keyboard.n().onPressDo({ if (self.comprobarSiGano(cajas) and personajeSimple.position() == game.at(4,0) ) {self.terminar()} })
		keyboard.r().onPressDo({ self.restart() })
		keyboard.t().onPressDo({ self.terminar() })
		
		keyboard.up().onPressDo({ personajeSimple.moverArriba() })
		keyboard.down().onPressDo({ personajeSimple.moverAbajo() })
		keyboard.right().onPressDo({ personajeSimple.moverDerecha() })
		keyboard.left().onPressDo({ personajeSimple.moverIzquierda() })
		// en este no hacen falta colisiones
		
		game.whenCollideDo(personajeSimple, { elemento => personajeSimple.empuja(elemento) })
	}
	
	method restart() {
		game.clear()
		self.configurate()
	}
	
	method dibujar(dibujo) {
		game.addVisual(dibujo)
		return dibujo
	}
	
	method comprobarSiGano(cajas) {
		return cajas.all{ c => c.estaBienPosicionada() }
	}
	
	method terminar() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image="fondoCompleto.png"))
		game.addVisual(personajeSimple)
		// después de un ratito ...
		game.schedule(2500, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="finNivel1.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// ... limpio todo de nuevo
				game.clear()
				// y arranco el siguiente nivel
				nivelLlaves.configurate()
			})
		})
	}
		
}

