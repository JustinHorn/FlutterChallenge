# ReminderApp

Hi liebes Epap Team!

Mir war nicht klar wie ich die Edges Cases von monatlich wiederholenden Remindern behandeln sollte  
und habe stattdessen einen 4-Wochen-Zyklus mit eingebaut.  
Falls Ihr da eine genauere Vorstellung habt implementiere ich diese gerne.

Der minütige Zyklus existiert zu Testzwecken.

### Zum Notification Zyklus :

Funktion:  
Wird ein Reminder erstellt, werden für die nächsten 10 Termine Notifications geplant.  
Wird die App in neu gestartet, werden alte Notification abgesagt und neue geplant.  
Dies geschiet für den einzelnen Reminder auch wenn dieser inaktiv - aktiv geschaltet wird  
und dabei zwischen den Schritten gespeichert wurde.

Problem Fall:  
Startet ein Nutzer bei einer daily Notification die App nach 10 Tagen nicht neu,  
erhält dieser keine Notifications mehr.

Mögliche Lösung:  
Über ein Callback könnte es möglich sein, eine neue Notification zu planen,  
wenn die alte Ausgelöst wurde.
