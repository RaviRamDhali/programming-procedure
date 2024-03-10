import React, { useState } from "react";
import { Card, CardBody, Col, Container, Row } from "reactstrap";
import CaseHeader from "./CaseHeader";
import { useParams } from "react-router-dom";

const Case = () => {
    
    document.title = "CaseJacket | Case Reminder";
    
    //Get id from URL
    const { id } = useParams();  // do not use useLocation();
    console.log('id',id);
  
    
    const [caseHeaderActiveTabId, setcaseHeaderActiveTabId] = useState("1");
    
    return (
      <React.Fragment>
        <Row>
          <Col lg={12}>
            <div className="page-content">
              <Container fluid>
                <CaseHeader caseHeaderActiveTabId={caseHeaderActiveTabId} />
                <Card>
                  <CardBody>
                    <h4 className="card-title">Case</h4>
                    <p className="card-title-desc">Case details</p>
                  </CardBody>
                </Card>
              </Container>
            </div>
          </Col>
        </Row>
      </React.Fragment>
    );
}

export default Case;
