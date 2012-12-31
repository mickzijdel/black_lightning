users = []
user_names = []
user_ids = {}

updateUserNames = ->
  user_names = []

  $.each users, (i, user) ->
    user_name = "#{user.first_name} #{user.last_name}"

    user_names.push user_name
    user_ids[user_name] = user.id

  return

userUpdater = (item) ->
  # Update user id
  this.$element.parent().find('.user_id').val(user_ids[item])

  return item

addUserAutocomplete = ->
  users = JSON.parse($('[name="users_list"]').val())
  updateUserNames()
  $('.team_member .user_name').typeahead
    source:  user_names
    updater: userUpdater
  .change ->
    $container = $(this).parent()
    value = $(this).val()
    if user_names.indexOf(value) == -1
      $container.find('.user_id').val(null)

      return if value == ""

      $container.find('.no-such-user').slideDown()
      $container.addClass('error')
    else
      $container.find('.no-such-user').slideUp()
      $container.removeClass('error')

  return

jQuery ->
  return if $('[name="users_list"]').length == 0

  addUserAutocomplete()
  return

$(document).on "nested:fieldAdded", (event) ->
  addUserAutocomplete()
  return