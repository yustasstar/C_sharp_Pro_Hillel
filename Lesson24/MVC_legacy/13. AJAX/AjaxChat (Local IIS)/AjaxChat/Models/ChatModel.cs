﻿using System;
using System.Collections.Generic;

namespace AjaxChat.Models
{
    public class ChatModel
    {
        // Все пользователи чата
        public List<ChatUser> Users;

        // все сообщения
        public List<ChatMessage> Messages;

        public ChatModel()
        {
            Users = new List<ChatUser>();
            Messages = new List<ChatMessage>();

            Messages.Add(new ChatMessage()
            {
                Text = "Чат запущен " + DateTime.Now
            });
        }
    }
    public class ChatUser
    {
        public string Name;
        public DateTime LoginTime;
    }

    public class ChatMessage
    {
        // автор сообщения, если null - автор сервер
        public ChatUser User;
        // время сообщения
        public DateTime Date = DateTime.Now;
        // текст
        public string Text = "";

    }
}