function handleLogout() {
    var form = document.getElementById('logout-form');
    
    // perform AJAX request
    var xhr = new XMLHttpRequest();
    xhr.open(form.method, form.action, true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                // clear sessionStorage to prevent back navigation after logout
                sessionStorage.clear();
                
                document.getElementById('logout-confirmation').style.display = 'block';
                
                // redirect to the home page or another appropriate page
                window.location.href = "<%= request.getContextPath() %>/index.jsp";
            } else {
                console.error('Error during logout:', xhr.status, xhr.statusText);
            }
        }
    };
    
    // send the form data
    xhr.send(new FormData(form));
    
    return false;
}
