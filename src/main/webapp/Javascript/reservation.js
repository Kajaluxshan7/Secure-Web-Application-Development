    console.log("Hello");
    function showConfirmationPopup(bookingId) {
        // Set the bookingId in the hidden input
        document.getElementById('bookingIdToCancel').value = bookingId;

        // Show the confirmation popup
        document.getElementById('confirmationPopup').style.display = 'block';
    }

    function hideConfirmationPopup() {
        // Hide the confirmation popup
        document.getElementById('confirmationPopup').style.display = 'none';
    }
        // Consolidated cancelReservation function
        function cancelReservation() {
            var bookingId = document.getElementById('bookingIdToCancel').value;

            // Validate bookingId to prevent XSS
            if (!/^\d+$/.test(bookingId)) {
                console.error('Invalid bookingId');
                hideConfirmationPopup();
                return;
            }

            // Ajax request to call the server-side cancelReservation method
            fetch('CancelReservationServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'bookingId=' + encodeURIComponent(bookingId)
            })
            .then(response => {
                if (response.ok) {
                    console.log("Reservation canceled successfully");
                    // Update the UI or perform any other actions
                } else if (response.status === 401) {
                    console.error("Unauthorized: User not authenticated");
                } else if (response.status === 400) {
                    console.error("Bad Request: Invalid bookingId");
                } else {
                    console.error("Error canceling reservation");
                }
                hideConfirmationPopup();
                location.reload();
            })
            .catch(error => {
                console.error("Error canceling reservation:", error);
                hideConfirmationPopup();
            });
        }
