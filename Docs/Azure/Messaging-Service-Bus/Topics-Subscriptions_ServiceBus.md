# Topics and Subscription in Azure Service Bus

In contrast to queues (processing of a message by a single consumer), topics and subscriptions provide a one-to-many form of communication in a `publish and subscribe` pattern. 

`Publisher` sends a message to a topic and one or more `subscribers` receive a copy of the message.



Some key points:
1. `Consumers` don't receive messages directly from the topic. Instead, consumers receive messages from `subscriptions` of the topic.
2. A `topic subscription` resembles a virtual `queue` that receives copies of the messages that are sent to the topic
3. Each published message is made available to each `subscription` registered with the `topic`.
4. The `subscriptions` can use additional filters to restrict the messages that they want to receive