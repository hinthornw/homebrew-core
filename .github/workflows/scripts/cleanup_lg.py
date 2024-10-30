import re
import os

content = open("Formula/l/langgraph-cli.tmp.rb").read()
existing_content = open("Formula/l/langgraph-cli.rb").read()

# Extract description, license, and bottle block from existing content
existing_desc = re.search(r'desc "(.+?)"', existing_content)
existing_license = re.search(r'license "(.+?)"', existing_content)
existing_bottle = re.search(r"bottle do(.+?)end", existing_content, re.DOTALL)

# Update description
if existing_desc:
    content = re.sub(r'desc ".*?"', f'desc "{existing_desc.group(1)}"', content)

# Add license
content = re.sub(
    r'(sha256 ".*?")',
    '\\1\n  license "MIT"',
    content,
    count=1,
)

# Add bottle block
if existing_bottle:
    bottle_block = f"  bottle do{existing_bottle.group(1)}end\n"
    content = re.sub(r'(license ".*?"\n)', f"\\1\n{bottle_block}", content)

# Update Python dependency
content = re.sub(r"depends_on \"python3\"", 'depends_on "python@3.13"', content)

# Update install method
content = re.sub(
    r"def install.*?end",
    "def install\n    virtualenv_install_with_resources\n  end",
    content,
    flags=re.DOTALL,
)

# Update test block
test_block = """test do
    (testpath/"graph.py").write <<~PYTHON
      from langgraph.graph import StateGraph
      builder = StateGraph(list)
      builder.add_node("anode", lambda x: ["foo"])
      builder.add_edge("__start__", "anode")
      graph = builder.compile()
    PYTHON

    (testpath/"langgraph.json").write <<~JSON
      {
        "graphs": {
          "agent": "graph.py:graph"
        },
        "env": {},
        "dependencies": ["."]
      }
    JSON

    system bin/"langgraph", "dockerfile", "DOCKERFILE"
    assert_path_exists "DOCKERFILE"
    dockerfile_content = File.read("DOCKERFILE")
    assert_match "FROM", dockerfile_content, "DOCKERFILE should contain 'FROM'"
  end"""
content = re.sub(r"test do.*?end", test_block, content, flags=re.DOTALL)

open("Formula/l/langgraph-cli.rb", "w").write(content)

# if os.path.exists("Formula/l/langgraph-cli.tmp.rb"):
#     os.remove("Formula/l/langgraph-cli.tm.rb")
