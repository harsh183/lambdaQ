# LambdaQ

A simple RabbitMQ based lambda like service which creates new queues for each arbritary function and auto-scales workers based on execution time.

  * Simple for developers. Just define and deploy functions to the api without providing another other than the language name and function.

  * Fault tolerance and load distribution to worker pools powered by RabbitMQ

  * Out of the box simple scaling - worker pools increase and shrink in size based on response time allowing users to target particular response times.

  * Can be extended to support RabbitMQ compatable technologies, hence it can be extended for many complex use cases by utilizing existing libraries.

  * Most of the infrastructure is quite language agnostic. With the addition of new templating and parsing it can support many more programming languages.

## Usage

To deploy a function submit a POST request at `domain/submit` with the request body in the form of {"language": "ruby", "function": "{YOUR CODE HERE}"}

## Build

Note: Depending on docker setup you may have to use sudo.

1. Install ruby and bundler.

2. Use bundler to get all ruby dependencies.
```
bundle
```

3. Build the docker image
```
docker build .
```

4. Start the rabbitMQ server (note if there are any existing processes, use `docker stop` and `docker rm` to remove them)
```
sudo ./start-rabbit.sh
```

5. Install tmux.
```
sudo apt-get install tmux
```

6. Start running the Sinatra server
```
ruby server.rb
```

## Contributor guide

Refer to [CONTRIBUTING.md](https://github.com/harsh183/lambdaQ/CONTRIBUTING.md)

## License

MIT License

Copyright (c) 2019 Harsh Deep, Prerana Kiran, Nicholas Husin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

