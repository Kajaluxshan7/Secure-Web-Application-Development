$(document).ready(function () {
    // client-side form validation
    $("#reservation-form").submit(function (event) {
        // reset previous error messages
        $(".error-message").text("");

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

function getCurrentDate() {
    var currentDate = new Date();
    var year = currentDate.getFullYear();
    var month = (currentDate.getMonth() + 1).toString().padStart(2, '0');
    var day = currentDate.getDate().toString().padStart(2, '0');
    return year + '-' + month + '-' + day;
}