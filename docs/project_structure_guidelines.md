# Project structure and style

Godot documentation recomments the following [folder structure](https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html).

## Summary of these guidelines

A basic folder structure can be seen depicted below.

> /project.godot
/docs/.gdignore  # See "Ignoring specific folders" below
/docs/learning.html
/models/town/house/house.dae
/models/town/house/window.png
/models/town/house/door.png
/characters/player/cubio.dae
/characters/player/cubio.png
/characters/enemies/goblin/goblin.dae
/characters/enemies/goblin/goblin.png
/characters/npcs/suzanne/suzanne.dae
/characters/npcs/suzanne/suzanne.png
/levels/riverdale/riverdale.scn

### Files, folders, and nodes

 - For the file names we use **snake_case**.
 - For the folder names we use **snake_case**.
 - For the node names we use **PascalCase**.

 |        | Good names                                      | Bad names                                                                           |
|--------|-------------------------------------------------|-------------------------------------------------------------------------------------|
| File   | player.gd, good_player.tsc, player_behaviour.gd | Player.gd, GoodPlayer.tsc, PlayerBehaviour.gd, playerBehavior.gd, playerbehavior.gd |
| Folder | tree_models                                     | TreeModels, TREEMODELS,treemodels,tree models,treeModels                            |
| Node   | PlayerCamera, PlayerMesh, PlayerCollider        | player_camera,playerMesh,player collider                                            |