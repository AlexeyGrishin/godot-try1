using Godot;
using System;

public class Helicopter : Node2D
{
    // Member variables here, example:
    // private int a = 2;
    // private string b = "textvar";

    [Export]
    public int Speed = 100;

    public void ProcessInput(float delta)
    {
        float dx = 0, dy = 0;
    
        if (Input.IsActionPressed("ui_left")) {
            dx = -1;
        } else if (Input.IsActionPressed("ui_right")) {
            dx = +1;
        }
        this.Position.Set(this.Position.x + Speed*dx, this.Position.y + Speed*dy);
    }

    public override void _PhysicsProcess(float delta)
    {
        this.ProcessInput(delta);
    }

    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here

        (this.GetNode("AnimationPlayer") as AnimationPlayer).Play("idle");
        
    }

//    public override void _Process(float delta)
//    {
//        // Called every frame. Delta is time since last frame.
//        // Update game logic here.
//        
//    }
}
