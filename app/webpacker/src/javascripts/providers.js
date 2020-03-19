import Swal from 'sweetalert2'

$(document).on('turbolinks:load', function() {
    $("[data-behavior='delete']").click(function(e) {
        e.preventDefault()
        Swal.fire({
            title: 'Are you sure?',
            text: 'You will not be able to recover this...',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'No, keep it'
        }).then((result) => {
            let parentContainer = $(this).closest('.provider-container')
            let headerText = $(this).closest('.provider-container').find('h4').text()
            if (result.value) {
                $.ajax({
                    url: $(this).attr("href"),
                    dataType: "JSON",
                    method: "DELETE",
                    success: function() {
                        parentContainer.fadeOut(600)
                        Swal.fire('Deleted!', `☠️ ${headerText} is gone forever ☠️`, 'success')
                    }
                });
            } else if (result.dismiss === Swal.DismissReason.cancel) {
                Swal.fire(`${headerText} is safe... for now 😎`, '', 'info')
            }
        })
    })

    document.body.addEventListener('ajax:success', function(event) {
        var message = event.detail[0]['message']
        Swal.fire('Hooray!', message, 'success')
    });
    document.body.addEventListener('ajax:error', function(event) {
        var message = event.detail[0]['message']
        Swal.fire('Oops...', message, 'error')
    });
});
