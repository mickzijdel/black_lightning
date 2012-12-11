# See https://gist.github.com/1862479

$.rails.allowAction = (element) ->
  # If the link holds the 'disabled' data attribute, get out
  if element.data('disabled')
    return false
  # The message is something like "Are you sure?"
  message = element.data('confirm')
  # If there's no message, there's no data-confirm attribute,
  # which means there's nothing to confirm
  return true unless message

  # Read the detail and require-type data attributes. Use type-confirm to force
  # the user to type the given string as confirmation (GitHub style).
  detail = element.data('detail') or ""
  type_confirm = element.data('type-confirm')

  # Clone the clicked element (probably a delete link) so we can use it in the dialog box.
  $link = element.clone()
    # We don't necessarily want the same styling as the original link/button.
    .removeAttr('class')
    # We don't want to pop up another confirmation (recursion)
    .removeAttr('data-confirm')
    # We want a button
    .addClass('btn').addClass('btn-danger')
    # We want it to sound confirmy
    .html("Confirm")

  # Create the modal box with the message
  modal_html = """
               <div class="modal" id="delete_modal">
                 <div class="modal-header">
                   <a class="close" data-dismiss="modal">&times;</a>
                   <h3>#{message}</h3>
                 </div>
                 <div class="modal-body">
                   <p>#{detail}</p>
                 </div>
                 <div class="modal-footer">
                   <a data-dismiss="modal" class="btn">Cancel</a>
                 </div>
               </div>
               """
  $modal_html = $(modal_html)

  if type_confirm
    confirm_input = $("<input id='type-confirm-input' style='width: 100%;'>")

    $modal_html.find('.modal-body').append(confirm_input)

    confirm_input.on 'keypress', ->
      setTimeout (->
        if confirm_input.val() == type_confirm
          $link.removeData('disabled')
          $link.removeClass('disabled')
        else
          $link.data('disabled', 'true')
          $link.addClass('disabled')
      ), 100
    $link.data('disabled', 'true')
    $link.addClass('disabled')

  # Add the new button to the modal box
  $modal_html.find('.modal-footer').append($link)
  # Pop it up
  $modal_html.modal()
  # Prevent the original link from working
  return false