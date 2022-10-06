# Fahrradverleih

Implementierung des Fahrradverleihs mit Flutter.

# Umgebungsvariablen

Parameter, welche von der Entwicklungsumgebung abhängig sind, z.B. die URL der Rad-API oder der
API-Key für Google Maps, werden in einer lokalen `.env` Datei abgelegt.

Nach dem Klonen sollte diese Datei erstellt werden; eine Übersicht mit den verfügbaren Keys
kann einfach der `.env.example` Datei entnommen werden.

# BLoC

Für das State-Management und die Umsetzung des MVVM-Patterns wurde in diesem Projekt
die [BLoC-Library](https://bloclibrary.dev/) eingesetzt.

Relevante Punkte in der Dokumentation sind die Punkte
[Architektur](https://bloclibrary.dev/#/architecture) (Aufbau und Prinzipien) und die
[Beschreibung des Flutter-Spezifischen Pakets](https://bloclibrary.dev/#/flutterbloccoreconcepts).
Letzteres erläutert die Interaktion zwischen BLoC-Klassen und Flutter-Widgets näher.
