import jinja2
import yaml

# Define the list of Ingress annotations (customize this as needed)
annotations_list = [
    {"nginx.ingress.kubernetes.io/rewrite-target": "/"},
    {"nginx.ingress.kubernetes.io/affinity": "cookie"},
    # Add more annotations here
]

# Define other variables for the template
template_vars = {
    "ingress_name": "",
    "host": "",
    "path": "",
    "path_type": "Prefix",
    "service_name": "your-service-name",
    "service_port": 80,
}

# Load the Jinja2 template
template_loader = jinja2.FileSystemLoader(searchpath=".")
template_env = jinja2.Environment(loader=template_loader)
template = template_env.get_template("template.yaml.j2")

# Generate and save 1000 Ingress objects
for i in range(1, 1001):
    template_vars["ingress_name"] = f"ingress-{i}"
    template_vars["host"] = f"example{i}.com"
    template_vars["path"] = f"/path{i}"

    # Choose a random annotation for each Ingress (customize this logic)
    template_vars["ingress_annotations"] = annotations_list[i % len(annotations_list)]

    # Render the template
    rendered_yaml = template.render(template_vars)

    # Save each Ingress object to a separate file
    with open(f"ingress-{i}.yaml", "w") as f:
        f.write(rendered_yaml)
