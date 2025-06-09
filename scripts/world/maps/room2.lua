return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 22,
  height = 15,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 13,
  properties = {
    ["name"] = "Test Map - Room 2",
    ["playerstate"] = "CLIMB"
  },
  tilesets = {
    {
      name = "castle",
      firstgid = 1,
      filename = "../tilesets/castle.tsx",
      exportfilename = "../tilesets/castle.lua"
    },
    {
      name = "fountain_climb",
      firstgid = 41,
      filename = "../tilesets/fountain_climb.tsx",
      exportfilename = "../tilesets/fountain_climb.lua"
    },
    {
      name = "libraryexcerpt",
      firstgid = 184,
      filename = "../tilesets/libraryexcerpt.tsx",
      exportfilename = "../tilesets/libraryexcerpt.lua"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 22,
      height = 15,
      id = 1,
      name = "cyltower_tiles",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        41, 54, 55, 55, 55, 41, 41, 42, 55, 54, 42, 54, 55, 55, 55, 42, 54, 41, 42, 55, 54, 41,
        41, 54, 41, 42, 41, 42, 54, 41, 55, 54, 55, 55, 42, 42, 42, 42, 54, 55, 42, 42, 41, 55,
        55, 41, 41, 55, 41, 42, 42, 54, 42, 54, 42, 54, 54, 41, 42, 55, 41, 54, 54, 54, 41, 42,
        55, 55, 54, 41, 42, 41, 41, 41, 42, 42, 54, 55, 54, 42, 42, 41, 42, 55, 55, 55, 55, 54,
        55, 54, 54, 54, 55, 41, 41, 54, 41, 54, 41, 54, 54, 41, 41, 54, 55, 42, 41, 54, 55, 55,
        42, 41, 41, 55, 55, 55, 42, 42, 55, 42, 55, 42, 54, 55, 55, 41, 55, 42, 42, 55, 42, 55,
        55, 54, 54, 54, 41, 54, 41, 54, 41, 55, 55, 41, 42, 42, 41, 42, 54, 42, 54, 54, 41, 41,
        54, 42, 41, 54, 42, 42, 42, 41, 42, 54, 55, 54, 41, 54, 41, 55, 42, 42, 54, 42, 41, 42,
        54, 41, 55, 42, 41, 41, 54, 55, 55, 55, 42, 41, 42, 54, 55, 42, 55, 55, 55, 41, 41, 54,
        55, 42, 41, 55, 54, 54, 42, 42, 54, 55, 54, 42, 41, 54, 54, 55, 42, 54, 54, 55, 42, 42,
        55, 55, 55, 41, 54, 54, 42, 55, 42, 54, 41, 42, 42, 55, 54, 42, 54, 41, 41, 41, 55, 41,
        42, 54, 55, 54, 41, 42, 41, 54, 54, 42, 41, 42, 41, 42, 55, 42, 54, 42, 41, 41, 42, 41,
        42, 42, 54, 55, 41, 54, 42, 42, 41, 41, 41, 55, 41, 55, 55, 41, 41, 41, 41, 41, 42, 42,
        55, 55, 54, 42, 55, 54, 42, 41, 42, 42, 54, 41, 41, 41, 42, 42, 41, 42, 55, 55, 42, 41,
        55, 41, 42, 41, 54, 55, 54, 41, 42, 55, 55, 55, 54, 54, 55, 42, 54, 41, 54, 42, 55, 42
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 22,
      height = 15,
      id = 2,
      name = "cyltower_decal",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        137, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        137, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        137, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        137, 0, 0, 0, 0, 0, 0, 0, 82, 83, 84, 85, 86, 87, 88, 0, 0, 0, 0, 0, 0, 0,
        150, 0, 0, 0, 0, 0, 0, 0, 95, 82, 97, 98, 99, 100, 101, 0, 0, 0, 0, 0, 0, 0,
        150, 0, 0, 0, 0, 0, 0, 0, 108, 109, 82, 111, 112, 113, 114, 0, 0, 0, 0, 0, 0, 0,
        150, 0, 0, 0, 0, 0, 0, 0, 121, 122, 123, 96, 111, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        150, 0, 0, 0, 0, 0, 0, 0, 134, 135, 136, 123, 124, 139, 0, 0, 0, 0, 0, 0, 0, 0,
        163, 0, 0, 0, 0, 0, 0, 0, 147, 148, 149, 0, 137, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        163, 0, 0, 0, 0, 0, 0, 0, 0, 0, 180, 0, 137, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        163, 0, 0, 0, 0, 0, 0, 0, 0, 0, 180, 0, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        163, 0, 0, 0, 0, 0, 0, 0, 0, 0, 180, 0, 163, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 184, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "collision",
      class = "",
      visible = true,
      opacity = 0.5,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {}
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "markers",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 8,
          name = "spawn",
          type = "",
          shape = "point",
          x = 300,
          y = 480,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "objects",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 9,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 480,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "room1",
            ["marker"] = "entry"
          }
        },
        {
          id = 12,
          name = "climbarea",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 880,
          height = 480,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
