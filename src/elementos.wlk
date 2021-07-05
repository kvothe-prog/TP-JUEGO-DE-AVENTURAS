import wollok.game.*
import personajes.*

class Bloque {
	var property position
	const property image = "market.png" 
}

class Caja {
	var property position
	const property image = "caja.png"
	
	method movete(direccion) {
		self.validarLugar(direccion)
		position = direccion.siguiente(position)
	}

	method validarLugar(direccion) {
		const posAlLado = direccion.siguiente(position) 
		var lugarValido = self.mePuedoMoverA(posAlLado) and game.getObjectsIn(posAlLado)
			.all{ obj => obj.puedePisarte(self) }
		
		if (!lugarValido) 
			throw new Exception(message = "No me puedo mover.")
	}

	method mePuedoMoverA(unaPosition){
		return self.dentroDelMapa(unaPosition)
	}
	
	method dentroDelMapa(unaPosition){
		return unaPosition.x().between(0,14) and unaPosition.y().between(0,14)
	}
	
	method image() {
		if (self.estaBienPosicionada())
			return "caja_ok.png"
		
		return "caja.png"
	}
	
	method estaBienPosicionada() {
		return position.x().between(5,9) and position.y().between(7,12)
	}	
	
}

class Enemigo {
	var property position
	const property image = "enemigo.png" 
	
}

class Llave {
	var property position
	var property image = "llave.png"
	var property fueRecogida = false
	
	method serRecogido() {
		fueRecogida = true
	}

}
