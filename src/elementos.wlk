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
	
	method serRecogido(pj) {
		fueRecogida = true
	}

}

class Salida {
	var property position
	var property image = "salida.png"
	
	method serRecogido(pj) {
	}
}

class Pollo {
	var property position
	var property image = "pollo.png"
	
	method serRecogido(pj){
		if(pj.modificador() != null ){
			pj.darEnergia(pj.modificador().efecto(0.randomUpTo(30).truncate(0), pj))}
		else {
			pj.darEnergia(0.randomUpTo(30).truncate(0))
		}
	}
	
}

class Duplicador {
	var property position
	var property image = "duplicador.png"
	
	method serRecogido(pj){
		pj.modificador(self)
	}
	
	method efecto(energia,pj){
		return energia * 2
	}
	
}

class Reforzador {
	var property position
	var property image = "reforzador.png"
	
	method serRecogido(pj){
		pj.modificador(self)
	}
	
	method efecto(energia,pj){
		var entrega 
		if (pj.energia() < 10){
			entrega = energia * 2 + 20
		}
		else {
			entrega = energia * 2
		}
		return entrega
	}
}

class TripleNada  {
	var property position
	var property image = "banana.png"
	
	method serRecogido(pj){
		pj.modificador(self)
	}
	
	method efecto(energia, pj){
		var entrega
		if (pj.energia().even()){
			entrega = energia * 3
		}
		else {
			entrega = energia
		}
		return entrega
	}
}

class CeldaSorpresa{
	var property position 
	const property image = "celda.png"
	var property activa = true

	method fueActivada(){
		activa = false
	}
	
	method celdasAdyacentes(){
		return [position.up(1),position.down(1),position.right(1),position.left(1)]
	}
	
	method image() {
		if (self.activa())
			return "celda.png"
		
		return "celdaDesactivada.png"
	}
	
	method sacaEnergia(pj){
		pj.sacarEnergia(15)
	}
	
	method darEnergia(pj){
		pj.darEnergia(30)
	}
	
	method teletransportar(pj) {
		pj.position(game.at(1,1))
	}
	
	method efecto(pj){
		if (activa){
			if(pj.energia() % 3 == 0 ){
				self.teletransportar(pj)
			}
			else if (pj.energia() % 3 == 1 ){
				self.darEnergia(pj)
			}
			else{
				self.sacaEnergia(pj)
			}
			}
	}
}

class PisoTrampa {
	var property position 
	const property image = "celdaAdyacente.png"
	const property celdaSorpresa

}