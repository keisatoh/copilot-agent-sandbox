package com.example

import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.plugins.cors.routing.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.Serializable

@Serializable
data class HelloResponse(val message: String)

@Serializable
data class HealthResponse(val status: String, val timestamp: Long)

fun main() {
    embeddedServer(Netty, port = 8080, host = "0.0.0.0", module = Application::module)
        .start(wait = true)
}

fun Application.module() {
    install(ContentNegotiation) {
        json()
    }
    
    install(CORS) {
        anyHost()
        allowCredentials = true
        allowNonSimpleContentTypes = true
    }
    
    install(CallLogging)
    
    routing {
        get("/") {
            call.respond(HelloResponse("Hello, Ktor Server!"))
        }
        
        get("/health") {
            call.respond(HealthResponse("OK", System.currentTimeMillis()))
        }
    }
}
