module Apress
  module Documentation
    module Extensions
      module RGL
        module Adjacency
          # Private: Расширение графа для замены вершины на новую
          def replace_vertex(old_v, new_v)
            @vertices_dict[new_v] = @vertices_dict.delete(old_v)

            @vertices_dict.each_value do |list|
              list.add(new_v) if list.delete?(old_v)
            end
          end
        end
      end
    end
  end
end
