# nerves-dashboard

A Nerves dashboard for in vehicle use, reading from an OBDII dongle and updating the GUI to display important information to the user.

This will be able to display stats from the ECU of the vehicle.
This will also be able to display gauges for things like RPM, water temp and anything that has a sensor output from the OBDII dongle.
This will be able to detect when a code is thrown by the ECU and then read and display the relevant information for that code in the GUI.

This will also be able to interface with and display stats for RV related things like secondary battery charge, water tank level, solar panel input. These things will require their own sensors and application to interpret the data and make it available to the dashboard.

This will also be able to interface with and display information from a weather station application, that is located in the vehicle to
provide data from it's sensors about temperature, humidity, barometric pressure and other weather related information.

There will be some historical data storage as well to log important stats about the vehicle, weather and additional sensors.

There is also some other module ideas for later that could be implemented and used with this dashboard,
such as a backup camera and blind spot camera that can be displayed on screen. A vehicle lock out system that
would disable the vehicles starting capabilities when the system has been locked by the user.
GPS vehicle tracking and finder functionality, (this would require some outward network connection to trigger from and log data to).
The GPS subsystem would require secondary battery connection to be always on to track and log coordinates even if vehicle is towed and not running. Parked vehicle collision detection, utilizing gyroscope and GPS information the vehicle could detect motion that would signify it was possibly in a collision while parked and notify the user.
Notifications should be it's own module that other subsystems can use to notify the user of an event that is important to them.

## Project Structure

* Dashboard - Scenic UI and Sensors
* Obd2Server - Backend that will talk to Ecu
* TestEcu - An ECU simulator that can be run on separate device
