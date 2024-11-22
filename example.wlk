class Persona {
    const property edad
    const property emociones = #{} 
//Punto 1 ===================================================
    method esAdolescente() 
        = self.edad().between(12, 19)

//punto 2 ====================================================
    method nuevaEmocion(emocion){
        emociones.add(emocion)
    }
         
//punto 3 ====================================================
    method estaPorExplotar() 
        = emociones.all({emocion => emocion.liberarse()})

    method viviUnEvento(evento) 
        = evento.vivirEvento(self)
}

class Emocion {    
    var property intensidad
    var property liberada = false 
    var property eventosExperimentados = 0
    var property intensidadElevada = 120

    method puedeLiberarse() = self.intensidadAlta() && !self.liberada()

    method liberarse(evento) {
        self.disminuirIntensidad(evento.impacto())  
        self.liberada(true)
    }
        
    method sumarEventoExperimentado() {
        eventosExperimentados += 1
    }

    method disminuirIntensidad(numero) {
        intensidad -= numero
    } 

    method intensidadAlta() = self.intensidad() >= self.intensidadElevada()
   
}

object intensidad {//cambio la itensidad de toda persona
}

class Furia inherits Emocion { 
    const property listaDePalabrotas = []

    method ListaDePalabrotas() 
        = listaDePalabrotas.any({palabrota => palabrota.size() > 7}) // verifico con


    method getPrimerPalabrota() 
    = listaDePalabrotas.first() //obtengo el primer elemento 

    method olvidarPrimerPalabrota(){
        self.olvidarPalabrotra(self.getPrimerPalabrota())
    } // lo elimino

    override method puedeLiberarse() 
        = super() && self.ListaDePalabrotas()  

    override method liberarse(evento){
        super(evento) 
        self.olvidarPrimerPalabrota()
    }

    method aprenderPalabrota(palabrota){
        listaDePalabrotas.add(palabrota)
    }

    method olvidarPalabrotra(palabrota) {
        listaDePalabrotas.remove(palabrota)
    }
}

class Alegria inherits Emocion {

    override method puedeLiberarse()  = super() && (self.eventosExperimentados() % 2)

    override method liberarse(evento) {
        if(!self.intensidadNegativa(evento.impacto()))
            super(evento)
        else
            self.intensidad(-self.sacarIntensidad(evento.impacto()))
    }

    method intensidadNegativa(intensidadEv) = self.sacarIntensidad(intensidadEv) < 0

    method sacarIntensidad(intensidadEv) = self.intensidad() - intensidadEv
}

class Tristeza inherits Emocion{
    var property causa = "melancolia" // creo q valdria declaralo asi porq solo seria un caso posible

    override method puedeLiberarse()
        = super() && self.causa() != "melancolia"

    override method liberarse(evento) {
        super(evento)
        self.causa(evento.descripcion())
    }
}

class Desagrado inherits Emocion{
    override method puedeLiberarse() 
        = self.eventosExperimentados() > self.intensidad() && super()
}

class Temor inherits Desagrado {

}

class Ansiedad inherits Emocion{
    const property estres
    const listaDeContrasPostEstres // ["quedarse pelado", "cansasio", "rendir mal"] por ejemplo

    override method puedeLiberarse() = super() && self.sumarIntensidad() > 100

    override method liberarse(evento) {
        super(evento)
        listaDeContrasPostEstres.clear()
    }

    method sumarIntensidad() = self.intensidad() + self.estres()
}

class Evento {
    const property impacto 
    const property descripcion 

    method vivirEvento(persona) {
      self.liberarEmociones(persona)
    }

    method liberarEmociones(persona) {
        persona.emociones().forEach({emocion => emocion.sumarEventoExperimentado()})
        self.emocionesQueSePuedenLiberar(persona).forEach({emocion => emocion.liberarse(self)})
    }

    method emocionesQueSePuedenLiberar(persona) = persona.emociones().filter({emocion => emocion.liberarse()})

}

class GrupoDePersonas {
    const property personas = #{}

    method vivirEventoJuntos(evento) {
        personas.forEach({persona => persona.viviUnEvento(evento)})
    } 
}

