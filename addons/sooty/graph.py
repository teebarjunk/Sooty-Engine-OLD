import json
from graphviz import Digraph

with open(".temp_json.json", "r") as f:
    nodes = json.load(f)

graph = Digraph(format="png")
graph.node_attr.update({
    'fontname': 'Arial',
    'color': '#000000',
    'style': 'filled',
    'fillcolor': '#eeeeee'
})

first = True
for nid in nodes:
    if nid == "9999":
        continue
    
    node = nodes[nid]
    #print(node, nid)
    
    shape = "rect"
    color = "black"
    style = "filled"
    fillcolor = "#eeeeee"
    
    # first node
    if first:
        first = False
        shape = "invhouse"
        color = "#ADEE0E"
        fillcolor = "#E8F3CD"
    
    # calls
    if not node["goto"] and node["call_from"]:
        shape = "oval"
        color = "gray"
    
    # final nodes
    if 9999 in node["goto"]:
        if not node["call_from"] and not node["goto_from"]:
            style = "dotted"
        else:
            shape = "house"
            color = "#1FCBF5"
            fillcolor = "#B8E1EA"
    
    graph.node(nid, shape=shape, style=style, color=color, fillcolor=fillcolor, label=node["name"])

for nid in nodes:
    node = nodes[nid]
    for nid2 in node["goto"]:
        if nid2 == 9999:
            continue
        graph.edge(nid, str(nid2))
    
    for nid2 in node["call"]:
        graph.edge(nid, str(nid2), arrowhead="none", color="gray", style="dotted")

#def check_jump(d):
    #if K_TYPE in d and d[K_TYPE] == "goto":
        #checked.append(d)
        #goto = d["goto"]
        #style = "dotted"
        #if isinstance(goto, str):
            #goto = [goto]
            #style = "solid"
        
        #for node_id in goto:
            #tup = (from_node, node_id)
            #if not tup in checked:
                #checked.append(tup)
                #graph.edge(from_node, node_id, style=style)

#tree_sorted = list(tree)
#tree_sorted.sort(key=lambda x: len(x["path"]))

#main
#graph.node("_TITLE_", color="gray", shape="box3d", label=f"<<b>{path.stem}</b><br/>{total_steps:,} steps<br/>{total_word_count:,} words<br/>{total_word_count/250.0} min>")

#for node in tree:
    #from_node = node["path"][-1]
    #print(from_node)
    #step_count = len(node["then"])
    #word_count = node["meta"]["words"]
    #minutes = (word_count / 250.0)
    #shape = "rect"
    #color = "black"
    #if from_node == "MAIN":
        #shape = "doubleoctagon"
        #color = "green"
    #elif from_node.startswith("_") and from_node.endswith("_"):
        #color = "gray"
    #graph.node(from_node, color=color, shape=shape, label=f"<<b>{from_node}</b><br/>{step_count:,} steps<br/>{word_count:,} words<br/>{minutes} min>")
    #dig(node["then"], check_jump)

graph.render(filename="story_graph_nodes")
print("graph saved to res://story_graph_nodes.png")
