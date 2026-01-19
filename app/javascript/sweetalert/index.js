import swal from 'sweetalert2/dist/sweetalert2.js'
import './alerts'

window.Swal = swal;

const Toast = Swal.mixin({
  toast: true,
  position: 'top-end',
  showConfirmButton: false,
  timer: 4500,
  customClass: {
    popup: 'colored-toast'
  },
  didOpen: (toast) => {
    toast.addEventListener('mouseenter', Swal.stopTimer)
    toast.addEventListener('mouseleave', Swal.resumeTimer)
  },
  iconColor: 'white'
})

const PersistentToast = Swal.mixin({
  toast: true,
  showConfirmButton: true,
  timerProgressBar: false
})

// Make these methods available to the window object, so that they can be used in inline scripts.
window.Toast = Toast;
window.PersistentToast = PersistentToast;

// Override Turbo's confirmation method to use SweetAlert
// This replaces the old Rails.confirm from @rails/ujs
// window.Turbo is set by @hotwired/turbo import in shared.js
window.Turbo.config.forms.confirm = (message) => {
  return new Promise((resolve) => {
    const swalWithBootstrap = swal.mixin({
      buttonsStyling: true,
    });

    // Parse verify text from message using [VERIFY:text] pattern
    // (Turbo only copies turbo-* attributes to synthetic forms, so we embed verify in the message)
    const verifyMatch = message.match(/\[VERIFY:(.+?)\]$/);
    const verifyText = verifyMatch ? verifyMatch[1] : null;
    const cleanMessage = verifyText ? message.replace(/\n\n\[VERIFY:.+?\]$/, '') : message;

    const swalConfig = {
      icon: 'warning',
      html: cleanMessage,
      title: "Are you sure?",
      showCancelButton: true,
      confirmButtonText: "Yes",
      cancelButtonText: "Cancel",
    };

    if (verifyText) {
      swalConfig.input = 'text';
      swalConfig.inputPlaceholder = `Type "${verifyText}" to confirm`;
      swalConfig.inputValidator = (value) => {
        if (value !== verifyText) {
          return `Please type "${verifyText}" exactly to confirm`;
        }
      };
    }

    swalWithBootstrap.fire(swalConfig).then((result) => {
      resolve(result.isConfirmed);
    });
  });
};
