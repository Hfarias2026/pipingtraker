import { BrowserRouter, Routes, Route } from "react-router-dom";
import Layout     from "./components/layout/Layout";
import Dashboard  from "./pages/Dashboard";
import LineDetail from "./pages/LineDetail";
import Soldadores from "./pages/Soldadores";
import Analitica  from "./pages/Analitica";

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index               element={<Dashboard />} />
          <Route path="linea/:id"    element={<LineDetail />} />
          <Route path="soldadores"   element={<Soldadores />} />
          <Route path="analitica"    element={<Analitica />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
