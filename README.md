# Autonomous Development Plugin

## Command Workflow

Run commands in this order:

1. `/oru-agent:design [feature]` - Create design document through guided conversation
2. `/oru-agent:spec [path]` - Generate RPG specification from design document
3. `/oru-agent:review [path]` - Validate spec before scaffolding
4. `/oru-agent:scaffold <spec>` - Create feature_list.json with implementation tasks
5. `/oru-agent:run [feature]` - Execute tasks from feature_list.json
6. `/oru-agent:validate [feature] [task-id]` - Validate completed task (optional)
