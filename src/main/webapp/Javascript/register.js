 $(document).ready(function () {
        // client-side form validation
        $("#reservation-form").submit(function (event) {
            // validate date
            var dateInput = $("#date").val();
            var currentDate = new Date();
            var selectedDate = new Date(dateInput);

            if (selectedDate < currentDate) {
                $("#date-error").text("Please select a date equal to or after today");
                event.preventDefault();
                return;
            } else {
                $("#date-error").text("");
            }

            // validate time
            var timeInput = $("#time").val();
            var currentTime = new Date();
            var selectedTime = new Date("1970-01-01 " + timeInput);

            if (selectedDate.getTime() === currentDate.getTime() && selectedTime <= currentTime) {
                $("#time-error").text("Please select a time after the current time");
                event.preventDefault();
                return;
            } else {
                $("#time-error").text("");
            }

            // validate vehicle registration number format
            var vehicleRegistrationInput = $("#vehicle_registration").val();
            var vehicleRegistrationPattern = /^[A-Za-z]{2}-\d{4}$/;
            if (!vehicleRegistrationPattern.test(vehicleRegistrationInput)) {
                alert("Please enter a valid vehicle registration number (e.g., AB-1234)");
                event.preventDefault();
                return;
            }

            // validate mileage
            var mileageInput = $("#current_mileage").val();
            if (isNaN(mileageInput) || mileageInput < 0) {
                alert("Please enter a valid mileage (a non-negative number)");
                event.preventDefault();
                return;
            }
        });
    });