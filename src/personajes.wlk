import wollok.game.*
import elementos.*

object personajeSimple {
	var property position = game.at(10,8)
	const property image = "player.png"	
	var property ultimaDireccion = arriba
	
	method empuja(unElemento) {
		try
			unElemento.movete(ultimaDireccion)
		catch e {
			console.println(e)
			self.retrocede()
		}
	}
	method recoge(unElemento){
		unElemento.serRecogido()
	}
	
	method retrocede() {
		position = ultimaDireccion.opuesto().siguiente(position)
	}
	
	method moverArriba(){
		if(self.mePuedoMoverA(position.up(1))){
			position = position.up(1)
			ultimaDireccion = arriba
		}
	}
	method moverAbajo(){
		if(self.mePuedoMoverA(position.down(1))){
			position = position.down(1)
			ultimaDireccion = abajo
		}
	}
	method moverDerecha(){
		if(self.mePuedoMoverA(position.right(1))){
			position = position.right(1)
			ultimaDireccion = derecha
		}
	}
	method moverIzquierda(){
		if(self.mePuedoMoverA(position.left(1))){
			position = position.left(1)
			ultimaDireccion = izquierda
		}
	}
	
	method mePuedoMoverA(unaPosition){
		return self.dentroDelMapa(unaPosition)
	}
	
	method dentroDelMapa(unaPosition){
		return unaPosition.x().between(0,14) and unaPosition.y().between(0,14)
	}
}

object arriba{
	method opuesto() = abajo
	method siguiente(position) = position.up(1) 
}
object abajo{
	method opuesto() = arriba
	method siguiente(position) = position.down(1)
}
object izquierda{
	method opuesto() = derecha
	method siguiente(position) = position.left(1)
}
object derecha{
	method opuesto() = izquierda
	method siguiente(position) = position.right(1)
}


