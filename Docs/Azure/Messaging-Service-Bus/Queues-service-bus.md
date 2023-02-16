# Queues

Queues offer `First In, First Out (FIFO)` message delivery to one or more competing consumers. That is, receivers typically receive and process messages in the order in which they were added to the queue. And, only one message consumer receives and processes each message

The producers (senders) and consumers (receivers) don't have to send and receive messages at the same time. That's because messages are stored durably in the queue. Furthermore, the producer doesn't have to wait for a reply from the consumer to continue to process and send messages.

# Receive modes
Two different modes in which consumers can receive messages from Service Bus

1. `Receive and delete`  when Service Bus receives the request from the consumer, it marks the message as being consumed and returns it to the consumer application
2. `Peek lock`  the receive operation becomes two-stage, which makes it possible to support applications that can't tolerate missing messages.

    Finds the next message to be consumed, locks it to prevent other consumers from receiving it, and then, return the message to the application.

    After the application finishes processing the message, it requests the Service Bus service to complete the second stage of the receive process. Then, the service marks the message as consumed.