import rclpy
from mcp.server.fastmcp import FastMCP
import requests
import subprocess
import json
from typing import List, Dict, Any, AsyncGenerator
import asyncio
import logging
import time

import rclpy.node

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Create an MCP server
mcp = FastMCP(name = "ros2_mcp", 
              version = "0.0.0", 
              description = "ROS2 MCP Server", 
              port=3002, 
              debug=True)

rclpy.init(args=None)

# Create a node
rclpy_node = rclpy.create_node("ros2_mcp")



# Returns a list of running ROS nodes
@mcp.tool()
async def get_nodes() -> list:
    """Returns a list of running ROS nodes"""
    # Get the list of node names
    node_names = rclpy_node.get_node_names()

    # Return the list of nodes
    return node_names

# Returns information about a given ROS node by name
@mcp.tool()
async def get_node_info(node_name: str) -> dict:
    """Returns information about a given ROS node by name"""
    # Get the list of node names
    node_names = rclpy_node.get_node_names()

    # Check if the node name is valid
    if node_name not in node_names:
        raise ValueError(f"Node '{node_name}' not found")

    node = rclpy.node.Node(node_name)

    # Get the node info
    info = {
        "name": node.get_name(),
        "namespace": node.get_namespace(),
        "topics": node.get_topic_names_and_types(),
        "services": node.get_service_names_and_types(),
        "parameters": node.get_parameters([])
    }

    # Return the node info
    return info



if __name__ == "__main__":
    logger.info(f"[Setup] Starting MCP-ROS2 server with SSE enabled on port {mcp.settings.port}")
    print(f"\n{'*' * 70}")
    print(f"* MCP-ROS2 server starting on http://localhost:{mcp.settings.port}/sse")
    print(f"* SSE streaming is enabled")
    print(f"{'*' * 70}\n")
    mcp.run("sse")