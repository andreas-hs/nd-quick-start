# Quick Start

To clone this repository along with its submodules, use the command with the `--recurse-submodules` option, which ensures automatic initialization and updating of each submodule during the cloning of the main repository:

```bash
git clone --recurse-submodules git@github.com:andreas-hs/nd-quick-start.git
```

To start all the necessary services, use the following command:

```bash
make start-all
```

To send messages to RabbitMQ, use the following command:

```bash
cd nd-laravel-app && make artisan rabbitmq:send-all
```

If the Go app is already running, all the data will be processed and sent to `destination_data` right away. If not, start it with:

```bash
cd nd-go-app && make up
```

## RabbitMQ Optimization

[RabbitMQService.php](nd-laravel-app/app/Services/RabbitMQService.php)

1. **Batch Message Sending**: Instead of sending each message separately, batch sending is used, significantly reducing the number of network requests and improving overall system efficiency.

2. **Prefetch Count**: A larger number of messages can be processed simultaneously, speeding up the message consumption process.

3. **Manual Acknowledgment Mode**: Allows acknowledgment of a batch of messages, reducing the time spent working with RabbitMQ.

4. **Asynchronous Publishing**: Messages are sent asynchronously, reducing the wait time for confirmation before sending the next message.

5. **Dead-Letter Exchange (DLX) and TTL (Time-to-Live)**: A Dead-Letter Exchange (DLX) queue with a TTL parameter is used to handle undelivered messages, improving message processing reliability.

#### Optimization Results

| Metric            | Synchronous, no batch | Asynchronous, with batch | Difference (seconds) | Difference (%) |
|-------------------|-----------------------|--------------------------|----------------------|----------------|
| **Total Time**     | 15.06 seconds         | 3.03 seconds             | 12.03 seconds        | **79.9%**      |
| **RabbitMQ Time**  | 14.59 seconds         | 0.48 seconds             | 14.11 seconds        | **96.7%**      |

## Using Transactions and Batch Insert in Seeder

[SourceDataSeeder.php](nd-laravel-app/database/seeders/SourceDataSeeder.php)

Transactions group multiple operations into one, providing:

1. **Data Integrity**: If an error occurs, all operations are rolled back.
2. **Speed**: Transactions speed up insertion by reducing the number of commits. In our case, this results in a speed increase of **approximately 4.65%** or **140 ms** for inserting 10,000 records:
   - **Without transaction**: 2.974 sec.
   - **With transaction**: 2.836 sec.

#### Why don’t we check the maximum string size of the query?

1. **Batch Insert**: We insert data in batches of **1,000 records**, which doesn't approach MySQL limits.
2. **Sufficient for the task**: The current batch approach optimizes insertion and does not require additional checks within the scope of the test task.