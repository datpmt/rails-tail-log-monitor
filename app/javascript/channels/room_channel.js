import consumer from "./consumer"

consumer.subscriptions.create({channel: "RoomChannel", path: 'log'}, {
  connected() {
    console.log('connecting')
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    if (window.location.pathname === '/log') {
      const logContent = document.getElementById('log-content');

      data.log_entries.forEach(log => {
        const logElement = document.createElement('div');
        logElement.innerHTML = log
        logContent.appendChild(logElement);
      });

      logContent.scrollTop = logContent.scrollHeight;
    }
  }
});

console.log('xxxx')