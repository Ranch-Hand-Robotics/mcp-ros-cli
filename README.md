# Model Context Protocol (MCP) interface for the ROS 2 command line interface

A Model Context Protocol interface to the ROS 2 command line interface allowing language models to introspect ROS installations, execute commands, and retrieve results. It is designed to be use within Visual Studio Code, with the Github Copilot MCP Server support, and is not tested outside that environment.

> NOTE: This project assumes that the ROS environment is part of the user's login shell. For example on bash, the following lines should be in your `~/.bashrc` file:

```bash
# Source ROS 2 installation
source /opt/ros/humble/setup.bash
```

## Walkthrough
 ![Coming Soon](https://img.shields.io/badge/Coming%20Soon-8A2BE2)
 
<!-- iframe width="100%" height="600" src="https://www.youtube.com/@rh_robotics" title="ROS 2 MCP Server" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe -->

## Installation
Clone the repository and install the package using pip:

```bash
cd ~
git clone https://github.com/Ranch-Hand-Robotics/mcp-ros-cli.git 
pip install -r mcp-ros-cli/requirements.txt
```

Open Visual Studio Chat (top of the screen using the github icon), login to Github if nessesary. Set the chat to use `agent mode`. Then select the tool icon, and add the `mcp-ros-cli` tool to your workspace. The resulting json file should look like:
```json
{
    "servers": {
        "ros2": {
            "type": "stdio",
            "command": "mcp",
            "args": [
                "run",
                "${workspaceFolder}/server.py"
            ],
        }
    }
}
```

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request with your changes. If you have any questions or suggestions, feel free to open an issue.

### Development
To set up a development environment, we recommend using the "Server Side events" feature of the MCP. This allows you to run the MCP server separately from the chat and connect to it from your local machine. To do this, follow these steps:

```bash
cd ~
git clone https://github.com/Ranch-Hand-Robotics/mcp-ros-cli.git
pip install -r mcp-ros-cli/requirements.txt
```

Then, in visual studio code, open the folder `mcp-ros-cli`, then run the provided python debug entry.
Update `.vscode/mcp.json` to use the sse option

```json 
{
    "servers": {
        "ros2": {
            "type": "sse",
            "url": "http://localhost:3002/sse"
        }
    }
}
```

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.



