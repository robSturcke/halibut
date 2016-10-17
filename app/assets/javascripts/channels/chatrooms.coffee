App.chatrooms = App.cable.subscriptions.create "ChatroomsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    active_chatroom = $("[data-behavior='messages'][data-chatroom-id='#{data.chatroom_id}']")
    if active_chatroom.length > 0

      # Insert the message
      active_chatroom.append("<div><strong>#{data.username}:</strong> #{data.body}</div>")

      if document.hidden
        if $(".strike").length == 0
          active_chatroom.append("div class='strike'><span>Unread Messages</span></div>")

        if document.hidden && Notification.permission == "granted"
          new Notification(data.username, {body: data.body})

        else
          App.last_read_at.update(data.chatroom_id)

          active_chatroom.append("<div><strong>#{data.username}:</strong> #{data.body}</div>")

    else
      $("[data-behavior='chatroom-link'][data-chatroom-id='#{data.chatroom_id}']").css("font-weight", "bold")

  send_message: (chatroom_id, message) ->
    @perform "send_message", {chatroom_id: chatroom_id, body: message}
